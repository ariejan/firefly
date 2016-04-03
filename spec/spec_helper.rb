# Require this file for unit tests
ENV['HANAMI_ENV'] ||= 'test'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/apps/admin/application.rb'
  add_filter '/apps/web/application.rb'
  add_filter '/apps/api/application.rb'
end

require_relative '../config/environment'
require 'minitest/autorun'
require 'minitest/reporters'
require 'byebug'

require 'mocha/mini_test'

Minitest::Reporters.use!

Hanami::Application.preload!
