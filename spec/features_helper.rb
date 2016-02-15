# Require this file for feature tests
require_relative './spec_helper'

require 'capybara'
require 'capybara/dsl'
require 'rack/test'

Capybara.app = Hanami::Container.new

class MiniTest::Spec
  include Capybara::DSL
  include Rack::Test::Methods

  def app
    Hanami::Container.new
  end
end
