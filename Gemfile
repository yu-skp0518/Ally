source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '4.0.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.6'
# Use Puma as the app server
gem 'puma', '~> 6.4'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# JavaScript 圧縮（Rails 7 では uglifier の代わりに terser）
gem 'terser', '>= 1.1'
# Rails 7 でも Sprockets アセットパイプラインを利用する場合
gem 'sprockets-rails', '>= 3.4'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'

# Build JSON APIs with ease.
gem 'jbuilder', '~> 2.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4', require: false
# Ruby 4.0 で msgpack 1.4.x のネイティブ拡張が失敗するため、1.7 系を明示（bootsnap が利用）
gem 'msgpack', '~> 1.7'

group :development, :test do
  gem 'byebug', platforms: [:mri, :windows]
end

group :development do
  gem 'web-console', '>= 4.2'
  gem 'listen', '>= 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0'
  # N+1 クエリ検出
  gem 'bullet'
end

group :test do
  gem 'capybara', '>= 3.36'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files
gem 'tzinfo-data', platforms: [:windows, :jruby]
# Ruby 4.0 で標準ライブラリから外れたため明示的に追加
gem 'ostruct'   # json 等が利用
gem 'mutex_m'   # spring / spring-watcher-listen が利用

# 追加したgem（Rails 7.2 対応のため 4.9 以上）
gem 'devise', '>= 4.9'
# refile は Rails 7 / Rack 2 と非互換のため Active Storage を使用
gem 'kaminari', '~> 1.2'
gem 'bootstrap', '~> 4.5'
gem 'jquery-rails'
gem 'font-awesome-sass', '~> 5.13'
gem 'rails-i18n'

# 楽天API
gem 'rakuten_web_service'
gem 'dotenv-rails'

group :production do
  gem 'mysql2', '>= 0.5'
end
