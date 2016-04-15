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
  add_filter '/config/sidekiq.rb'
end

require_relative '../config/environment'
require 'minitest/autorun'
require 'minitest/reporters'
require 'byebug'

require 'mocha/mini_test'

Minitest::Reporters.use!

Hanami::Application.preload!

def url_item(url = 'http://test.host/test', opts = {})
  options = {
    type: 'url',
    content: url
  }.merge!(opts)

  ItemRepository.create(Item.new(options))
end
