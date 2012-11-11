# encoding: UTF-8
require 'rubygems'
require 'open-uri'
require 'cgi'
require 'yaml'
require 'sinatra'
require 'sinatra/activerecord'

begin
  require 'barby'
  require 'barby/outputter/png_outputter'
rescue LoadError
end

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Firefly
  # Return the path to the root of this Firefly instance
  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end

  # Get the current environment
  def self.environment
    @environment ||= ENV['RACK_ENV'] || "development"
  end
end

require 'firefly/database'
require 'firefly/config'
require 'firefly/version'
require 'firefly/base62'
require 'firefly/code_factory'
require 'firefly/url'
require 'firefly/server'

