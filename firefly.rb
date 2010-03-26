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
require 'dm-aggregates'
require 'valerii'

set :sessions, false

if ENV['RACK_ENV'] == 'development'
  DataMapper::Logger.new($stdout, :debug)
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/firefly_#{ENV['RACK_ENV']}.sqlite3")

module FireFly
  class Url
    include DataMapper::Resource

    property :id,           Serial
    property :url,          String
    property :code,         String
    property :created_at,   DateTime
  
    # Encode a URL and return the encoded ID
    def self.encode(url)
    
      @result = self.first(:url => url)
    
      if @result.nil?
        @result = self.create(:url => url)
        @result.update(:code => Valerii.encode(@result.id.to_i))
      end
    
      return @result.code
    end
  
    # Decode a code to the original URL
    def self.decode(code)
      @result = Url.first(:code => code)  
      return @result.nil? ? nil : @result.url
    end
  end
end

DataMapper.auto_migrate!

get '/' do
  "Hello world!"
end

# POST /add?url=http://ariejan.net
#
# Returns the shortened URL
post '/add' do
  if params[:api_key] != settings.api_key
    status 401
    return "Permission denied: Invalid API key." 
  end
  
  if params[:url].nil? || params[:url] == ""
    "Invalid or no URL specified" 
  else
    "http://#{settings.hostname}/#{FireFly::Url.encode(params[:url])}"
  end
end

# GET /b3d
#
# Redirect to the shortened URL
get '/:code' do
  url = FireFly::Url.decode(params[:code])
  
  if url.nil?
    status 404
    "Sorry, that code is unknown."
  else
    redirect url
  end
end