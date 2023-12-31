require 'cucumber'
require 'selenium-webdriver'
require 'rspec'
require 'capybara'
require 'capybara/cucumber'
require 'site_prism'
require 'pry'

ENVIRONMENT = ENV['ENVIRONMENT']
ENVIRONMENT_CONFIG = YAML.load_file(File.dirname(__FILE__) + "/environments/#{ENVIRONMENT}.yml")
URL = ENVIRONMENT_CONFIG['url']

SELENIUM_WAIT = Selenium::WebDriver::Wait.new(timeout: 10)

Capybara.register_driver :my_chrome do |app|
    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
        'goog:chromeOptions' => { 
            'args' =>[
                '--ignore-ssl-errors', 
                '--ignore-certificate-errors',
                '--disable-popup-bloking', 
                '--disable-gpu', 
                '--disable-translate', 
                '--no-sandbox', 
                '--acceptInsecureCerts=true',
                '--disable-impl-side-painting', 
                '--debug_level=3', 
                '--incognito', 
                '--start-maximizide', 
                '--window-size=1420,835'
            ] 
        }
    )

    if ENV['HEADLESS']
        caps['goog:chromeOptions']['args'] << '--headless'
        caps['goog:chromeOptions']['args'] << '--desable-site-isolation-trials'
    end

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 90
    options = { browser: :chrome, capabilities: caps, http_client: client }
    Capybara::Selenium::Driver.new(app, options)
end

Capybara.register_driver :my_edge do |app|
    caps = Selenium::WebDriver::Remote::Capabilities.edge(
        'ms:edgeOptions' => {
            'args' => [
                '--ignore-ssl-errors',
                '--ignore-certificate-errors',
                '--disable-popup-blocking',
                '--disable-gpu',
                '--disable-translate',
                '--no-sandbox',
                '--acceptInsecureCerts=true',
                '--disable-impl-side-painting',
                '--incognito',
                '--start-maximized',
                '--window-size=1420,835'
            ]
        }
    )
  
    if ENV['HEADLESS']
        caps['ms:edgeOptions']['args'] << '--headless'
        caps['ms:edgeOptions']['args'] << '--disable-site-isolation-trials'
    end
  
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 90
    options = { browser: :edge, capabilities: caps, http_client: client }
    Capybara::Selenium::Driver.new(app, options)
end

Capybara.register_driver :my_firefox do |app|
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        'moz:firefoxOptions' => {
            'args' => [
                '--ignore-ssl-errors',
                '--ignore-certificate-errors',
                '--disable-popup-blocking',
                '--disable-gpu',
                '--disable-translate',
                '--no-sandbox',
                '--acceptInsecureCerts=true',
                '--disable-impl-side-painting',
                '--private',
                '--window-size=1420,835'
            ]
        }
    )
  
    if ENV['HEADLESS']
        caps['moz:firefoxOptions']['args'] << '--headless'
        caps['moz:firefoxOptions']['args'] << '--disable-site-isolation-trials'
    end
  
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 90
    options = { browser: :firefox, capabilities: caps, http_client: client }
    Capybara::Selenium::Driver.new(app, options)
end

Capybara.default_driver        = ENV['BROWSER'].to_sym
Capybara.app_host              = URL
Capybara.default_max_wait_time = 10
