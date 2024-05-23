# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]

  gem 'rspec-rails', '~> 6.1.0'

  gem 'factory_bot_rails'
end

group :test do
  gem 'shoulda-matchers', '~> 6.0'

  gem 'database_cleaner-active_record', '~> 2.1'

  gem 'faker', '~> 3.3', '>= 3.3.1'

  gem 'rails-controller-testing', '>= 1.0.1'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  gem 'annotate'

  gem 'rubocop', '~> 1.63', require: false

  gem 'rails_best_practices'

  gem 'reek', '~> 6.3'
end

gem 'haml-rails', '~> 2.0'

gem 'html2haml', '~> 2.3'

gem 'lefthook', '~> 1.6', '>= 1.6.10'

gem 'devise', '~> 4.9', '>= 4.9.4'

gem 'image_processing', '>= 1.2'
