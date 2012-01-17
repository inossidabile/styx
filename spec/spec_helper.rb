require 'rubygems'
require 'bundler'
Bundler.require :development
require 'capybara/rspec'
Combustion.initialize! :action_controller, :action_view, :sprockets
Bundler.require :default
require 'rspec/rails'
require 'capybara/rails'

RSpec.configure do |config|
  config.mock_with :rspec
end