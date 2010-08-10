require 'rubygems'
require 'open-uri'
require 'cgi'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-transactions'
require 'dm-aggregates'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

if ENV['RACK_ENV'] == 'development'
  DataMapper::Logger.new($stdout, :debug)
end

require 'firefly/config'
require 'firefly/version'
require 'firefly/base62'
require 'firefly/url'
require 'firefly/server'
