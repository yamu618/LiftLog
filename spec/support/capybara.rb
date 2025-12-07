require "capybara/rails"
require "selenium-webdriver"

Capybara.configure do |config|
  config.default_max_wait_time = 30
end

Capybara.register_driver :remote_chrome_docker do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[--no-sandbox --disable-gpu --headless=new --window-size=1680,1050 --disable-dev-shm-usage]
  )
  
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch("http://chrome:4444/wd/hub"),
    options: options
  )
end
