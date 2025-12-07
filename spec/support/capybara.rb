require "capybara/rails"
require "selenium-webdriver"

Capybara.configure do |config|
  config.default_max_wait_time = 30

  config.default_driver = :selenium_chrome_headless 
  config.javascript_driver = :selenium_chrome_headless
end

#Capybara.register_driver :selenium_chrome_headless do |app|
#  options = Selenium::WebDriver::Chrome::Options.new
#  options.add_argument("--no-sandbox")
#  options.add_argument("--headless=new")
#  options.add_argument("--disable-gpu")
#  options.add_argument("--disable-dev-shm-usage")
#  options.add_argument("--window-size=1680,1050")
#
#  Capybara::Selenium::Driver.new(
#    app,
#    browser: :chrome,
#    options: options
#  )
#end

Capybara.register_driver :remote_chrome_docker do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[--no-sandbox --disable-gpu --window-size=1680,1050 --disable-dev-shm-usage]
  )
  
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch("SELENIUM_DRIVER_URL", "http://chrome:4444/wd/hub"), # サービス名でアクセス
    options: options
  )
end
