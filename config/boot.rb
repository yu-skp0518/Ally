ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# Windows: autoprefixer-rails は JScript 非対応のため Node.js (V8) を明示
ENV['EXECJS_RUNTIME'] = 'Node' if Gem.win_platform?

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
