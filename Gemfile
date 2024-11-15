source "https://rubygems.org"

# Core gems
gem "rails", "~> 7.1.0"
gem "pg", "~> 1.5"
gem "puma", "~> 5.0"

# API and Authentication
gem "bcrypt", "~> 3.1.7"
gem "rack-cors"

# Money handling
gem "money-rails"

# HTTP clients
gem "httparty"

# Development and test gems
group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "database_cleaner-active_record"
  gem "shoulda-matchers"
  gem "vcr"
  gem "webmock"
  gem "brakeman"
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rails-omakase"
end

group :development do
  gem "annotate"
end

gem "bootsnap", "~> 1.18"

gem 'latest_stock_price'
