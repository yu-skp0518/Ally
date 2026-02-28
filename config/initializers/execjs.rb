# frozen_string_literal: true

# Windows: ExecJS のランタイムは config/boot.rb で ENV['EXECJS_RUNTIME'] = 'Node' に設定。
# Node.js 未インストールの場合は「Could not find a JavaScript runtime」等のエラーになる。
# 対処: https://nodejs.org/ から LTS をインストールし、ターミナルを開き直す。
