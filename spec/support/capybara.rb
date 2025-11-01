require "capybara/rails"
require "selenium-webdriver"

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--no-sandbox")
  options.add_argument("--headless")
  options.add_argument("--disable-gpu")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1680,1050")

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV["SELENIUM_DRIVER_URL"] || "http://chrome:4444/wd/hub",
    capabilities: options
  )
end

Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.default_driver = :remote_chrome
  config.javascript_driver = :remote_chrome
end
