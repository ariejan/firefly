require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-aggregates'

set :sessions, false

if ENV['RACK_ENV'] == 'development'
  DataMapper::Logger.new($stdout, :debug)
end

if ENV['FIREFLY_DB']
  DataMapper.setup(:default, ENV['FIREFLY_DB'])
else
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/firefly_#{ENV['RACK_ENV']}.sqlite3")
end

module FireFly
  class B62
    
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split('')
    BASE = 62
    
    def self.encode(value)
      s = []
      while value >= BASE
        value, rem = value.divmod(BASE)
        s << CHARS[rem]
      end
      s << CHARS[value]
      s.reverse.to_s
    end

    def self.decode(str)
      str = str.split('').reverse
      total = 0
      str.each_with_index do |v,k|
        total += (CHARS.index(v) * (BASE ** k))
      end
      total
    end
  end
  
  class Url
    include DataMapper::Resource

    property :id,           Serial
    property :url,          String,     :key => true
    property :code,         String,     :key => true
    property :created_at,   DateTime
  
    # Encode a URL and return the encoded ID
    def self.encode(url)
    
      @result = self.first(:url => url)
    
      if @result.nil?
        @result = self.create(:url => url)
        @result.update(:code => FireFly::B62.encode(@result.id.to_i))
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

# Upgrade the database is necessary. 
DataMapper.auto_upgrade!

get '/' do
  "Hello world!"
end

# POST /add?url=http://ariejan.net
#
# Returns the shortened URL
post '/api/add' do
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
    redirect url, 301
  end
end