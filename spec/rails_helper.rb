require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/cuprite'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]
  # FactoryBot統合
  config.include FactoryBot::Syntax::Methods
  # Deviseヘルパーメソッド
  config.include Devise::Test::IntegrationHelpers, type: :system

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!
  
  RSpec.configure do |config|
    config.before(:each, type: :system) do
      driven_by :cuprite, options: {
        js_errors: true,             # JavaScript エラーを検出
        headless: true,              # ヘッドレスモードで実行
        slowmo: 0,                   # デバッグ時は 0.1 などに変更可能
        timeout: 10,                 # ページ読み込みタイムアウト
        window_size: [1400, 1400],   # ウィンドウサイズ
        browser_options: {
          "no-sandbox": nil,         # Docker環境で必要
          "disable-gpu": nil,        # GPU無効化
          "disable-dev-shm-usage": nil # /dev/shm問題回避
        }
      }
    end

    Capybara.configure do |c|
      c.default_max_wait_time = 10
      c.default_driver = :rack_test   # JSなしテスト用
      c.javascript_driver = :cuprite  # JSありテスト用
    end
  end
end
