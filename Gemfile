source 'https://gems.ruby-china.com'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'pry'

gem 'active_link_to',           '1.0.4'     # Use active_link_to helper.
gem 'acts-as-taggable-on',      '6.0.0'     # Manage tags.
gem 'bcrypt',                   '3.1.11'    # Use ActiveModel has_secure_password.
gem 'bootstrap-sass',           '3.3.6'     # Add page style.
gem 'bootstrap-will_paginate',  '1.0.0'     # Paginate with Boostrap styling.
gem 'bootstrap3-datetimepicker-rails', '4.17.47' # Add a datetime picker.
gem 'browser-timezone-rails',   '1.0.1'     # Set local timezone.
gem 'cancancan',                '2.0.0'     # Centralize authorization.
gem 'chartkick',                '2.3.5'     # Easily generate charts.
gem 'codemirror-rails',         '5.16.0'    # Add a code editor to views.
gem 'coffee-rails',             '4.2.2'     # Use default CoffeeScript adapter.
gem 'coffee-script-source',     '1.8.0'     # Enable CoffeeScript.
gem 'crypt_keeper',             '2.0.0.rc2' # Encrypt secure fields.
gem 'exception_notification',   '4.2.2'     # Get notified about exceptions.
gem 'gon',                      '6.1.0'     # Use Rails variables in Javascript.
gem 'httparty',                 '0.14.0'    # Send HTTP requests.
gem 'jbuilder',                 '2.7.0'     # Build JSON APIs.
gem 'jquery-datatables',        '1.10.16'   # Use jQuery datatables plug-in.
gem 'jquery-rails',             '4.1.1'     # Use jQuery as the JavaScript library.
gem 'jquery-ui-rails',          '6.0.1'     # Extend jQuery library.
gem 'momentjs-rails',           '2.9.0'     # Parse, manipulate, and format dates.
gem 'mysql2',                   '0.5.2'     # Use MySQL database.
gem 'paranoia',                 '2.4.1'     # Soft delete records.
gem 'premailer-rails',          '1.10.2'    # Add styling to emails automatically.
gem 'puma',                     '3.11.4'    # Serve the app.
gem 'rails',                    '5.2.2'     # Optimize for programmer happiness.
gem 'rails-controller-testing', '1.0.2'     # Bring back assert_template.
gem 'rails-html-sanitizer',     '1.0.4'     # Sanitizes methods.
gem 'rest-client',              '2.0.2'     # Use client for REST API calls.
gem 'sass-rails',               '5.0.6'     # Use SCSS for stylesheets.
gem 'stripe',                   '3.26.0'    # Use Stripe for billing.
gem 'stripe-ruby-mock',         '2.5.4'     # Use mock for Stripe tests.
gem 'silencer',                 '1.0.1'     # Silence logging events.
gem 'timezone_finder',          '1.5.7'     # Determine timezone by location.
gem 'turbolinks',               '5.0.1'     # Navigate your web app faster.
gem 'tzinfo-data',              '1.2017.2',
    platforms: %i[mingw mswin x64_mingw jruby] # Access IANA Time Zone database.
gem 'uglifier',                 '3.2.0'     # Compress JavaScript assets.
gem 'useragent',                '0.16.10'   # Check user agent data.
gem 'webpacker',                '3.5.3'     # Preprocess and bundle JavaScript.
gem 'will_paginate',            '3.1.6'     # Paginate.

gem 'devise'

gem 'qiniu'

gem 'active_model_serializers'

# files upload
gem "paperclip", "~> 5.0.0"

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

# Use mina for deployment
# gem 'capistrano-rails', group: :development
gem 'mina'

gem 'dotenv-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
