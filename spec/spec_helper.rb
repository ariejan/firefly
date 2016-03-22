# Require this file for unit tests
ENV['HANAMI_ENV'] ||= 'test'

require 'coveralls'
Coveralls.wear!

require_relative '../config/environment'
require 'minitest/autorun'
require 'minitest/reporters'
require 'byebug'

Minitest::Reporters.use!

Hanami::Application.preload!
