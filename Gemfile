# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

group :test do
  gem "rspec"
  gem "simplecov", require: false
end

group :development, :test do
  gem "pry"
  gem "standard"
end
