source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'

gem 'bootstrap-sass', '3.0.3.0'
gem 'google_drive'
gem 'figaro' #creates the config/application.yml file ignored by Git
gem 'gibbon' #mailchimp API API
gem 'newrelic_rpm' #tracking and pinging from newrelic
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1' #sortable links on inventory (user and admin) and request pages (admin)
gem 'sucker_punch', '~> 1.0' #for background jobs
gem 'fist_of_fury', '~> 0.2.0' #to allow sucker punch to do recurring jobs

# Use sqlite3 as the database for Active Record
group :development do
	gem 'sqlite3', '1.3.8'
end

group :development, :test do
	gem 'rspec-rails', '~> 2.14.0.rc1' #was '2.13.1' update needed beacuse otherwise assertion methods 'assert_form' didnt' work
	gem 'factory_girl_rails'
end

group :test do
	gem 'selenium-webdriver', '2.35.1' #capybara dependency
	gem 'capybara', '2.1.0' #enables natural language tests
	gem 'faker' #generates fake data for tests
	gem 'launchy', '~> 2.4.2' #enables save_and_open_page so I can see what's rendered
	# gem 'database_cleaner'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
	gem 'unicorn'
	gem 'rails_12factor'
	gem 'pg', '0.17.1'
end

	
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
