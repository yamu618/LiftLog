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
  
  config.before(:each, type: :system) do
    driven_by :cuprite, using: :chrome, options: {
      js_errors: true,           # JavaScriptエラーを検出
      headless: true,            # ヘッドレスモードで実行
      slowmo: 0,                 # 操作間の待機時間（デバッグ時は0.1など）
      timeout: 10,               # タイムアウト設定
      process_timeout: 10,       # プロセスタイムアウト
      window_size: [1400, 1400], # ウィンドウサイズ
      browser_options: {
        'no-sandbox': nil,       # Docker環境で必要
        'disable-gpu': nil,      # GPU無効化
        'disable-dev-shm-usage': nil  # メモリ使用量削減
      }
    }
  end

  Capybara.configure do |config|
    config.default_max_wait_time = 10
    config.default_driver = :cuprite
    config.javascript_driver = :cuprite
  end
end
