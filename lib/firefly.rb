# encoding: UTF-8
require 'rubygems'
require 'open-uri'
require 'cgi'
require 'yaml'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-transactions'
require 'dm-aggregates'

require 'escape_utils'
require 'escape_utils/url/rack'

begin
  require 'barby'
  require 'barby/outputter/png_outputter'
rescue LoadError
end

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

if ENV['RACK_ENV'] == 'development'
  DataMapper::Logger.new($stdout, :debug)
end

module Firefly
  # Get the current environment
  def self.environment
    ENV['RACK_ENV'] || "development"
  end
end

require 'firefly/config'
require 'firefly/version'
require 'firefly/base62'
require 'firefly/code_factory'
require 'firefly/url'
require 'firefly/server'

