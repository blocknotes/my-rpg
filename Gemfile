# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

group :development do
  gem "rubocop"
end

group :test do
  gem "rspec"
  gem "simplecov", require: false
end

group :development, :test do
  gem "pry"
end
