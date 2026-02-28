# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 管理ユーザー（環境変数で指定、既にいればスキップ）
if ENV['ADMIN_EMAIL'].present? && ENV['ADMIN_PASSWORD'].present? && Admin.find_by(email: ENV['ADMIN_EMAIL']).nil?
  Admin.create!(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'])
end

# 開発用ユーザー（フィクスチャベース。楽天API なしで手元で挙動確認する用）
[
  { email: 'test@test', name: 'test', nick_name: '田中太郎', password: 'testtest' },
  { email: 'qqq@qqq', name: 'test1', nick_name: '山田花子', password: 'qqqqqq' },
  { email: 'aaa@aaa', name: 'test2', nick_name: '鈴木一郎', password: 'aaaaaa' }
].each do |attrs|
  next if User.exists?(email: attrs[:email])
  User.create!(attrs)
rescue ActiveRecord::RecordInvalid
  # 同じ name のユーザーが既にいるときはスキップ
end

%w[中学受験 高校受験 大学受験 資格試験 TOEIC TOEFL IELTS その他].each do |name|
  Genre.find_or_create_by!(name: name)
end

%w[国語 算数 理科 社会 現代文 数学 英語 公民 政治/経済 地理 科学 物理 化学 情報 その他].each do |name|
  Subject.find_or_create_by!(name: name)
end

# --- 楽天API を使わない開発用デモデータ（本・コメント・ブックマーク・フォロー）---
# 手元で一覧や投稿詳細を見たいとき用。既にサンプル本がある場合はスキップ。
def demo_books_exist?
  Book.exists?(isbn: 978_4_04_100000_1)
end

unless demo_books_exist?
  user1 = User.find_by(email: 'test@test')
  user2 = User.find_by(email: 'qqq@qqq')
  user3 = User.find_by(email: 'aaa@aaa')
  genre_high = Genre.find_by(name: '高校受験')
  genre_univ = Genre.find_by(name: '大学受験')
  genre_qual = Genre.find_by(name: '資格試験')
  sub_math = Subject.find_by(name: '数学')
  sub_eng = Subject.find_by(name: '英語')
  sub_gen = Subject.find_by(name: '国語')

  placeholder_img = 'https://placehold.jp/100x140.png?text=book'

  books_data = [
    { user: user1, genre: genre_high, subject: sub_math, isbn: 978_4_04_100000_1,
      title: '高校数学の参考書サンプル', author: '山田 太郎', story: '解説が分かりやすく、受験対策に重宝しました。', rate: 4.5 },
    { user: user1, genre: genre_univ, subject: sub_eng, isbn: 978_4_04_100000_2,
      title: '大学受験 英語長文読解', author: '佐藤 花子', story: '長文の読み方のコツが身につきます。', rate: 4.0 },
    { user: user2, genre: genre_qual, subject: sub_eng, isbn: 978_4_04_100000_3,
      title: 'TOEIC 公式問題集の使い方', author: 'ETS', story: '本番に近い形式で練習できました。', rate: 5.0 },
    { user: user2, genre: genre_high, subject: sub_gen, isbn: 978_4_04_100000_4,
      title: '現代文の読み方', author: '鈴木 一郎', story: '国語が苦手だったので、この本で基礎を固めました。', rate: 3.5 },
    { user: user3, genre: genre_univ, subject: sub_math, isbn: 978_4_04_100000_5,
      title: '大学数学 入門', author: '高校数学の会', story: '大学の授業の予習に使っています。', rate: 4.0 },
  ]

  books_data.each do |data|
    next unless data[:user] && data[:genre] && data[:subject]
    Book.find_or_create_by!(isbn: data[:isbn], user_id: data[:user].id) do |b|
      b.genre_id = data[:genre].id
      b.subject_id = data[:subject].id
      b.title = data[:title]
      b.author = data[:author]
      b.item_caption = '（シード用サンプル）'
      b.item_url = 'https://example.com'
      b.publisher_name = 'サンプル出版'
      b.item_price = 1000
      b.large_image_url = placeholder_img
      b.medium_image_url = placeholder_img
      b.small_image_url = placeholder_img
      b.story = data[:story]
      b.rate = data[:rate]
      b.is_deleted = false
    end
  end

  # コメント
  b1 = Book.find_by(isbn: 978_4_04_100000_1)
  b2 = Book.find_by(isbn: 978_4_04_100000_2)
  if b1 && user2 && !b1.comments.exists?(user_id: user2.id)
    b1.comments.create!(user_id: user2.id, body: '私もこの本で勉強しました。おすすめです！')
  end
  if b1 && user3 && !b1.comments.exists?(user_id: user3.id)
    b1.comments.create!(user_id: user3.id, body: 'わかりやすいレビューありがとうございます。')
  end
  if b2 && user3 && !b2.comments.exists?(user_id: user3.id)
    b2.comments.create!(user_id: user3.id, body: '英語の長文、苦手なので参考になりました。')
  end

  # ブックマーク
  user2&.bookmarks&.find_or_create_by!(book_id: b1.id) if b1 && user2
  user3&.bookmarks&.find_or_create_by!(book_id: b2.id) if b2 && user3

  # フォロー（user2, user3 が user1 をフォロー）
  user2&.relationships&.find_or_create_by!(follower_id: user1.id) if user1 && user2
  user3&.relationships&.find_or_create_by!(follower_id: user1.id) if user1 && user3

  puts 'Demo data (books, comments, bookmarks, relationships) created.'
end