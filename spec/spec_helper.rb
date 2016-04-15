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

puts "Running tests against #{ENV['DB']}."

def url_item(url = 'http://test.host/test', opts = {})
  options = {
    age: 0
  }.merge!(opts)

  params = {
    type: 'url',
    content: url,
    created_at: Time.now - options[:age] * 3600
  }

  ItemRepository.create(Item.new(params))
end
