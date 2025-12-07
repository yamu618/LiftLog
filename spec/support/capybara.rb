require "capybara/rails"
require "selenium-webdriver"

Capybara.configure do |config|
  config.default_max_wait_time = 30

  config.default_driver = :remote_chrome_docker
  config.javascript_driver = :remote_chrome_docker
end

Capybara.register_driver :remote_chrome_docker do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[--no-sandbox --disable-gpu --headless=new --window-size=1680,1050 --disable-dev-shm-usage]
  )
  
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch("SELENIUM_DRIVER_URL", "http://chrome:4444/wd/hub"), # サービス名でアクセス
    options: options
  )
end
