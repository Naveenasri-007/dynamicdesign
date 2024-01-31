source 'https://rubygems.org'

ruby '3.2.2'
gem 'mysql2', '~> 0.5'
gem 'rails', '~> 7.1.2'
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'pagy', '6.3.0'
gem 'sprockets-rails'
# for pagination
gem 'bootsnap', require: false
gem 'devise'
gem 'sidekiq', '~> 7.2.1'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.0.8'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'faker'
group :development, :test do
  gem 'debug'
  gem 'fabrication'
  gem 'jsonapi-serializer'
  gem 'rspec-rails'
end

group :development do
end

group :test do
  gem 'capybara'
  gem 'json_matchers'
  gem 'rspec'
end
