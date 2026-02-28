# Ruby 4.0.1 対応の変更内容

## 概要

- **Ruby**: 2.6.3 → 4.0.1（`.ruby-version` と `Gemfile`）
- **Rails**: 5.2 → 7.2（Ruby 4.0 は Rails 5.2 非対応のため）

## 主な変更

### Gemfile

- `ruby '4.0.1'`
- `rails '~> 7.2.0'`
- `sqlite3` を `~> 1.6` に指定
- `puma` を `~> 6.4` に更新
- `uglifier` を廃止し、`terser` で JS 圧縮
- `sprockets-rails` を明示的に追加（Rails 7 で Sprockets を使うため）
- `listen` の `< 3.2` 制限を削除
- `chromedriver-helper` を廃止し、`webdrivers` に変更
- `jbuilder` を `~> 2.7` に更新

### 設定

- `config/application.rb`: `config.load_defaults 7.2`
- `config/environments/production.rb`: `config.assets.js_compressor = :terser`

### コントローラ

- `redirect_to request.referer` を `redirect_back fallback_location: ...` に変更（Rails 5.3 以降の推奨）

### ビュー・レイアウト

- 管理画面の `form_with` に `local: true` を追加（Rails 7 ではデフォルトが remote）
- レイアウトで Turbo（UMD）を CDN から読み込み（`link_to method: :delete` 等のため。Rails 7 では rails-ujs 非同梱）
- `stylesheet_link_tag` の `data-turbolinks-track` を削除

## 次の作業

1. **bundle install** を実行してください。
2. エラーが出る場合は、該当 gem のバージョンを Ruby 4.0 / Rails 7.2 対応のものに上げてください（例: refile, kaminari）。
3. **bundle exec rails db:migrate** でマイグレーションを実行（必要に応じて）。
4. **bundle exec rails s** で起動し、画面・削除リンク等の動作を確認してください。

## 注意

- 本番で JavaScript を CDN に依存したくない場合は、Turbo を vendor に配置するか、importmap / jsbundling への移行を検討してください。
- Refile など一部 gem が Rails 7 / Ruby 4 で未対応の場合は、代替手段（Active Storage 等）の検討が必要になる場合があります。
