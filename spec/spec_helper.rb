# Require this file for unit tests
ENV['HANAMI_ENV'] ||= 'test'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/spec/'
  add_filter 'app/admin/application.rb'
  add_filter 'app/web/application.rb'
  add_filter 'app/api/application.rb'
end

require_relative '../config/environment'
require 'minitest/autorun'
require 'minitest/reporters'
require 'byebug'

Minitest::Reporters.use!

Hanami::Application.preload!
