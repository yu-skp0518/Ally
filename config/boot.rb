ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# デプロイ先（Railway 等）で RAILS_ENV 未設定だと "Missing secret_key_base for 'environment' environment" で落ちるため、
# 未設定のときは production にフォールバックする
if ENV['RAILS_ENV'].to_s.strip.empty? && ENV['RACK_ENV'].to_s.strip.empty?
  ENV['RAILS_ENV'] = 'production'
end

# Windows: autoprefixer-rails は JScript 非対応のため Node.js (V8) を明示
ENV['EXECJS_RUNTIME'] = 'Node' if Gem.win_platform?

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
