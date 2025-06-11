#
# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in oas_hanami.gemspec
gemspec

gem "irb"
gem "rake", "~> 13.0"

gem "minitest", "~> 5.16"

gem "rubocop", "~> 1.21"

gem "hanami", "~> 2.2"
gem "hanami-assets", "~> 2.2"
gem "hanami-controller", "~> 2.2"
gem "hanami-db", "~> 2.2"
gem "hanami-router", "~> 2.2"
gem "hanami-validations", "~> 2.2"
gem "hanami-view", "~> 2.2"

gem "dry-operation"
gem "dry-types", "~> 1.7"
gem "puma"
gem "sqlite3"

group :development do
  gem "hanami-webconsole", "~> 2.2"
end

group :development, :test do
  gem "dotenv"
end

group :cli, :development do
  gem "hanami-reloader", "~> 2.2"
end

group :cli, :development, :test do
  gem "hanami-rspec", "~> 2.2"
end

group :test do
  # Database
  gem "database_cleaner-sequel"

  # Web integration
  gem "capybara"
  gem "rack-test"
end
