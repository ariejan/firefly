require 'sinatra/base'

module Firefly
  class Server < Sinatra::Base
    set :sessions, false
    
    attr_reader :config
    
    def initialize config = {}, &blk
      super
      @config = config.is_a?(Config) ? config : Firefly::Config.new(config)
      @config.instance_eval(&blk) if block_given?
      
      begin
        DataMapper.setup(:default, @config[:database])
        DataMapper.auto_upgrade!
      rescue
        puts "Error setting up database connection. Please check the `database` setting in config.ru"
        exit(1)
      end
    end
    
    def validate_api_permission
      if params[:api_key] != config[:api_key]
        status 401
        return "Permission denied: Invalid API key." 
      end
    end
    
    get '/' do
      "Hello world!"
    end
    
    # POST /add?url=http://ariejan.net
    #
    # Returns the shortened URL
    post '/api/add' do
      validate_api_permission

      if params[:url].nil? || params[:url] == ""
        "Invalid or no URL specified" 
      else
        "http://#{config[:hostname]}/#{Firefly::Url.encode(params[:url])}"
      end
    end
    
    # GET /b3d+
    #
    # Show info on the URL
    get '/api/info/:code' do
      validate_api_permission
      
      result = []
      
      url = Firefly::Url.decode(params[:code])
      
      if url.nil?
        result << "Sorry, that code is unknown."
      else
        result << "URL: #{url.url}"
        result << "Short URL: http://#{config[:hostname]}/#{url.code}"
        result << "Created at: #{url.created_at.to_time.to_s}"
        result << "Visits: #{url.visits}"
      end
      
      return result.join("\n")
    end
    
    # GET /b3d
    #
    # Redirect to the shortened URL
    get '/:code' do
      url = Firefly::Url.decode(params[:code])

      if url.nil?
        status 404
        "Sorry, that code is unknown."
      else
        url.visit!
        redirect url.url, 301
      end
    end    
  end
end

