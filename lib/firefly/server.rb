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
    
    get '/' do
      "Hello world!"
    end
    
    # POST /add?url=http://ariejan.net
    #
    # Returns the shortened URL
    post '/api/add' do
      if params[:api_key] != config[:api_key]
        status 401
        return "Permission denied: Invalid API key." 
      end

      if params[:url].nil? || params[:url] == ""
        "Invalid or no URL specified" 
      else
        "http://#{config[:hostname]}/#{Firefly::Url.encode(params[:url])}"
      end
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

