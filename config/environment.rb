# Load the Rails application.
require File.expand_path('../application', __FILE__)

ActionMailer::Base.smtp_settings = {
  user_name: ENV['owner'],
  password: ENV['password'],
  domain: ENV['domain'],
  address: ENV['address'],
  port: ENV['port'],
  authentication: ENV['authentication'],
  enable_starttls_auto: ENV['enable_starttls_auto']
}

# Initialize the Rails application.
GoogleTest::Application.initialize!
