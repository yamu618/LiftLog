require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

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
  # Railsのヘルパーメソッド
  config.include Rails.application.routes.url_helpers

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!

  config.before(:each, type: :system) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 4444
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    Capybara.ignore_hidden_elements = false
  end
end
