# Setup Bundler
begin
  require File.expand_path('.bundle/environment', __FILE__)
rescue LoadError
  require "rubygems"
  require "bundler"
  Bundler.setup
end

require 'rubygems'
require 'sinatra'
require 'dm-core'

module FireFly
  class Url
  end
end


get '/' do
  "Hello world!"
end