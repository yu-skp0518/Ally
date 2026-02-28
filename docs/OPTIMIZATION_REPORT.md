# Ally プロジェクト 最適化レポート

プロジェクト全体を確認し、最適化・修正できる箇所を洗い出しました。コミットは行っていません。

---

## 1. データベース・N+1 クエリ対策（優先度高）

### 1.1 書籍詳細・コメント一覧（Public / Admin）

**ファイル:** `app/controllers/public/books_controller.rb`, `app/controllers/admin/books_controller.rb`

- **現状:** `@comments = @book.comments.all.order(...).page(...)` のみで、ビューで `comment.user` や `comment.likes.count` を参照している。
- **問題:** コメント数に比例してユーザー取得・いいね数取得のクエリが発生（N+1）。
- **対応案:**
  ```ruby
  # public/books_controller.rb show
  @comments = @book.comments
    .includes(:user, :likes)
    .order(created_at: :desc)
    .page(params[:page])
  ```
  - 件数表示は `@amounts = @book.comments.count` の1回にし、`@amount` は Kaminari の `@comments.total_count` を使うとクエリ重複を防げます。

### 1.2 ユーザー詳細ページの投稿一覧

**ファイル:** `app/controllers/public/users_controller.rb`, `app/views/public/users/show.html.erb`

- **現状:** `@books = Book.where(user_id: @user.id, ...)` のみ。ビューで `book.comments.all.count` をループ内で実行。
- **問題:** 投稿数分の `comments.count` クエリが発生（N+1）。
- **対応案:**
  - コントローラで `@books = Book.where(...).includes(:comments)` にし、ビューでは `book.comments.size` を使用（メモリ上でカウント）。
  - または `Book.where(...).left_joins(:comments).group(:id).select('books.*, COUNT(comments.id) AS comments_count')` で一括取得。

### 1.3 ブックマーク一覧

**ファイル:** `app/controllers/public/bookmarks_controller.rb`, `app/views/public/bookmarks/index.html.erb`

- **現状:** `@bookmarks = Bookmark.where(user_id: @user.id)`。ビューで `bookmark.book` および `book.genre`, `book.subject`, `book.user`, `book.comments.count` を参照。
- **問題:** ブックマーク数×（book + genre + subject + user + comments）のクエリが発生。
- **対応案:**
  ```ruby
  @bookmarks = Bookmark
    .where(user_id: @user.id)
    .includes(book: [:genre, :subject, :user, :comments])
  ```

### 1.4 ジャンル・科目別書籍一覧

**ファイル:** `app/controllers/public/genres_controller.rb`, `app/controllers/public/subjects_controller.rb`  
**ビュー:** `app/views/public/genres/show.html.erb`, `app/views/public/subjects/show.html.erb`

- **現状:** `@books = @genre.books.where(...)` / `@subject.books.where(...)` のみ。ビューで `book.genre`, `book.subject`, `book.user`, `book.comments.count` を参照。
- **対応案:**
  ```ruby
  @books = @genre.books
    .where(is_deleted: false)
    .includes(:genre, :subject, :user)
  ```
  - `comments.count` が必要なら `includes(:comments)` の上でビューで `book.comments.size` を使うか、上記と同様に group/select で comments_count を付与。

### 1.5 管理側ユーザー一覧・検索結果

**ファイル:** `app/controllers/admin/users_controller.rb`, `app/views/admin/users/index.html.erb`  
**ファイル:** `app/controllers/admin/searches_controller.rb`, `app/views/admin/searches/search.html.erb`

- **現状:** `@users` や `@datas` をそのまま渡し、ビューで `user.books.count` をループ内で実行。
- **対応案:** 一覧取得時に `User.includes(:books)` や、必要なら `left_joins(:books).group(:id).select('users.*, COUNT(books.id) AS books_count')` で件数を一括取得。

### 1.6 いいね一覧（Public）

**ファイル:** `app/controllers/public/likes_controller.rb`

- **現状:** `@comments = Comment.joins(:likes).where(likes: { user_id: params[:user_id] }).order(...)`。ビューで `comment.user` 等を参照する場合は `includes(:user, :book)` があると安全。

---

## 2. モデル・アソシエーションの誤り（バグ・優先度高）

### 2.1 User モデル

**ファイル:** `app/models/user.rb`

- **現状:**
  - `has_many :comments, dependent: :destroy, through: :likes`
  - `has_many :likes, dependent: :destroy, through: :comments`
- **問題:**
  - Comment は `belongs_to :user` なので「ユーザーが書いたコメント」は `has_many :comments` でよいが、`through: :likes` にすると「いいねしたコメント」になって意味がずれる。
  - Like は `belongs_to :user` なので「ユーザーが付けたいいね」は `has_many :likes` のみでよく、`through: :comments` は不要。
- **対応案:**
  ```ruby
  has_many :comments, dependent: :destroy          # ユーザーが書いたコメント
  has_many :likes, dependent: :destroy             # ユーザーが付けたいいね
  has_many :liked_comments, through: :likes, source: :comment  # いいねしたコメント
  ```
  - コントローラで `Comment.joins(:likes).where(likes: { user_id: params[:id] })` としている箇所は、`current_user.liked_comments` や `@user.liked_comments` に寄せると意図が分かりやすくなります（既存の joins のままでも動作はする）。

### 2.2 Inquirie モデル名

**ファイル:** `app/models/inquirie.rb`, `db/schema.rb` では `inquiries` テーブル

- **問題:** モデル名が `Inquirie`（単数形が不自然）。Rails の慣習では `Inquiry` が自然。
- **対応:** モデルを `Inquiry` にリネームし、`inquirie` 参照をすべて `inquiry` に置き換える（コントローラ・ビュー・ルート等）。テーブル名は `inquiries` のままで問題ありません。

---

## 3. コントローラ・フロー・重複クエリ

### 3.1 書籍検索（キーワード未入力時）

**ファイル:** `app/controllers/public/books_controller.rb`（`search` アクション）

- **現状:** `render :search` の後に `flash[:notice] = "キーワードを入力してください。"` を設定している。
- **問題:** `render` では次のリクエストに flash が回らないため、このメッセージは表示されない。
- **対応案:** メッセージを出したい場合は `flash.now[:notice] = "キーワードを入力してください。"` を `render` の前に書く。または `redirect_to ...` にして flash を設定する。

### 3.2 書籍新規投稿フォーム（new）

**ファイル:** `app/controllers/public/books_controller.rb`（`new` アクション）

- **現状:** `params[:isbn]` で楽天 API を叩き、`first` で1件取ってから各属性を渡している。
- **問題:** `params[:isbn]` が空や、API が 0 件のときに `book` が `nil` になり、`book.isbn` 等で NoMethodError になる。
- **対応案:** `book = ... first` のあと `if book` で分岐し、存在しない場合は `redirect_to books_search_path, alert: "該当する書籍が見つかりませんでした"` などにする。

### 3.3 コメント件数の二重取得

**ファイル:** `app/controllers/public/books_controller.rb`, `app/controllers/admin/books_controller.rb`（`show`）

- **現状:** `@amount = @comments.count` と `@amounts = @book.comments.all.count` の2つを実行。
- **問題:** ページングありの `@comments` に対して `count` と、全件に対する `count` でクエリが2本立つ。またビューでは「○件表示（全○件）」のように使っている。
- **対応案:** `@amounts = @book.comments.count` のみにし、表示件数は `@comments.size` または Kaminari の `@comments.count`（現在のページの件数）。全件は `@amounts` をそのまま使う。

### 3.4 ジャンル・科目の件数クエリ

**ファイル:** `app/controllers/public/genres_controller.rb`, `app/controllers/public/subjects_controller.rb`

- **現状:** `@books = @genre.books.where(is_deleted: false)` と `@amount = @genre.books.where(is_deleted: false).count` で同じ条件を2回実行。
- **対応案:** `@books = @genre.books.where(is_deleted: false)` を変数に保持し、件数は `@amount = @books.count` とする（またはビューで `@books.size` / `@books.count` を使用）。同じリレーションなので SQL はキャッシュされる場合もありますが、意図をそろえた方が読みやすいです。

### 3.5 ログアウト後の分岐（ApplicationController）

**ファイル:** `app/controllers/application_controller.rb`（`after_sign_out_path_for`）

- **現状:** `elsif` の後に条件がなく、その下の `flash` と `root_path` が常に実行される可能性がある。
- **対応案:** 管理側ログアウトとそれ以外を明確に分ける。例: `else` で「ユーザー側」として `root_path` を返す。

---

## 4. ビュー・ルーティングの不整合

### 4.1 ブックマーク削除リンク

**ファイル:** `app/views/public/books/show.html.erb`

- **現状:** `book_bookmark_path(@book, [:id])` のように `[:id]` を渡している。
- **問題:** 削除対象は「その本に対する current_user のブックマーク」なので、ブックマークの id を渡す必要がある。`[:id]` では正しい id にならない。
- **対応案:** コントローラで `@bookmark = current_user.bookmarks.find_by(book_id: @book.id)` を渡すか、ビューで `current_user.bookmarks.find_by(book_id: @book.id)` を取得し、`book_bookmark_path(@book, @bookmark)` のように渡す。

### 4.2 フォロー解除（unfollow）リンク

**ファイル:** `app/views/public/users/show.html.erb`

- **現状:** `user_relationship_path(@user.id, )` と第2引数が空。
- **問題:** `destroy` では relationship の id が必要。第2引数がないとルーティングエラーになる可能性がある。
- **対応案:** 例: `user_relationship_path(@user, current_user.relationships.find_by(follower_id: @user.id))` のように、削除する relationship を渡す。

**ファイル:** `app/views/public/relationships/followings.html.erb`, `app/views/public/relationships/followers.html.erb`

- **現状:** `user_relationship_path(user, :id)` のようにシンボル `:id` を渡している。
- **対応案:** 各行の `user` が「フォローしている/されているユーザー」なら、`current_user` とそのユーザーから relationship を取得し、`user_relationship_path(user, relationship)` のように実 id を渡す。

### 4.3 いいね削除リンク

**ファイル:** `app/views/public/books/show.html.erb`

- **現状:** `book_comment_like_path(@book, comment, [:id])` と `[:id]` を渡している。
- **問題:** 削除対象は「そのコメントに対する current_user の like」なので、like の id を渡す必要がある。
- **対応案:** 例: `book_comment_like_path(@book, comment, comment.likes.find_by(user_id: current_user.id))` または、コントローラで「コメントごとの current_user の like」をまとめて渡し、ビューではその id を使う。

---

## 5. 検索・スペル

### 5.1 検索メソッド名の typo

**ファイル:** `app/controllers/public/searches_controller.rb`, `app/controllers/admin/searches_controller.rb`

- **現状:** `partical` というメソッド名で部分一致検索をしている。
- **対応案:** `partial` にリネーム（ビューやルートで `params[:how] == 'partical'` などがあれば一緒に `partial` に変更）。

---

## 6. 管理側の一貫性・運用

### 6.1 管理側書籍 update 後のリダイレクト

**ファイル:** `app/controllers/admin/books_controller.rb`

- **現状:** 更新後に `redirect_to book_path(@book)`（ユーザー側の書籍詳細）に飛んでいる。
- **対応案:** 管理画面内に留めるなら `redirect_to admin_book_path(@book)` に変更。意図的にユーザー側を見せる運用なら現状のままで可。

### 6.2 管理側書籍一覧

**ファイル:** `app/controllers/admin/books_controller.rb`（`index`）

- **現状:** `@books = Book.all` で並び順・ページングなし。
- **対応案:** 本数が増えると重くなるため、`order(created_at: :desc)` と Kaminari の `page(params[:page]).per(20)` などを検討。

---

## 7. セキュリティ・認可

### 7.1 ユーザー編集・更新

**ファイル:** `app/controllers/public/users_controller.rb`（`edit`, `update`）

- **現状:** `params[:id]` でユーザーを取得しているのみ。
- **問題:** 他ユーザーの id を指定すると他者のプロフィールを編集・更新できてしまう可能性がある。
- **対応案:** `edit` / `update` では `params[:id].to_i == current_user.id` のときだけ処理し、それ以外は `redirect_to root_path, alert: "権限がありません"` などにする。

### 7.2 ブックマーク index

**ファイル:** `app/controllers/public/bookmarks_controller.rb`（`index`）

- **現状:** `params[:user_id]` で任意のユーザーのブックマーク一覧を表示できる。
- **対応案:** 「自分のブックマークのみ」にするなら `@user = current_user` とし、`params[:user_id]` は使わないか、`params[:user_id].to_i == current_user.id` のときだけ表示する。

---

## 8. 開発環境・パフォーマンス検知

- **Bullet gem:** N+1 検出用に `gem 'bullet'` を development/test で導入し、`config/environments/development.rb` で有効にすると、上記のような N+1 をコードで見つけやすくなります。
- **Ruby / Rails:** 現在 Ruby 2.6.3 / Rails 5.2 です。サポート状況を確認し、余裕があればバージョンアップも検討するとよいです。

---

## 9. まとめ（優先度別）

| 優先度 | 内容 |
|--------|------|
| 高     | User モデルのアソシエーション修正（2.1）、ブックマーク・unfollow・いいね削除のリンク修正（4.1〜4.3）、ログアウト後の分岐（3.5） |
| 高     | N+1 対策（1.1〜1.6）、コメント件数の二重取得削減（3.3） |
| 中     | 検索キーワード未入力時の flash（3.1）、書籍 new の nil 対策（3.2）、検索メソッド名 typo（5.1） |
| 中     | 編集・更新・ブックマーク一覧の認可（7.1, 7.2） |
| 低     | Inquirie → Inquiry リネーム（2.2）、管理側 index の order/ページング（6.2）、管理側 update 後のリダイレクト先（6.1） |

このレポートを元に、必要な箇所から順に修正・最適化してください。コミットは行っていません。
