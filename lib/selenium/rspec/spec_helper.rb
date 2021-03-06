require 'rubygems'
require 'rspec/core'
require 'base64'
require 'fileutils'
require File.expand_path(File.dirname(__FILE__) + "/rspec_extensions")
require File.expand_path(File.dirname(__FILE__) + "/reporting/selenium_test_report_formatter")

RSpec.configure do |config|

  config.around(:each) do |example|
    begin 
      if selenium_driver && selenium_driver.session_started?
        selenium_driver.set_context "Starting example '#{self.example.metadata[:description]}'"
      end
    rescue Exception => e
      STDERR.puts "Problem while setting context on example start" + e
    end

    example.run

    begin 
      if actual_failure? 
        SeleniumTestReportFormatter.capture_system_state(selenium_driver, self.example)
      end
      if selenium_driver.session_started?
        selenium_driver.set_context "Ending example '#{self.example.metadata[:description]}'"
      end
    rescue Exception => e
      STDERR.puts "Problem while capturing system state" + e
    end
  end

end

