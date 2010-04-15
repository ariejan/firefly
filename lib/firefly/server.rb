require 'sinatra/base'
require 'haml'
require 'digest/md5'

module Firefly
  class Server < Sinatra::Base
    enable :sessions
    
    dir = File.join(File.dirname(__FILE__), '..', '..')

    set :views,   "#{dir}/views"
    set :public,  "#{dir}/public"
    set :haml,    {:format => :html5 }
    set :static,  true
    
    attr_accessor :config
    
    helpers do
      include Rack::Utils
      alias_method :h, :escape_html
      
      def url(*path_parts)
        [ path_prefix, path_parts ].join("/").squeeze('/')
      end
      alias_method :u, :url
      
      def path_prefix
        request.env['SCRIPT_NAME']
      end
      
      def set_api_cookie(key)
        session["firefly_session"] = Digest::MD5.hexdigest(key)
      end
      
      def has_valid_api_cookie?
        key = session["firefly_session"]
        key == Digest::MD5.hexdigest(config[:api_key])
      end
      
      def validate_api_permission
        if !has_valid_api_cookie? && params[:api_key] != config[:api_key]
          status 401
          return "Permission denied: Invalid API key." 
        end
      end
      
      def short_url(url)
        "http://#{config[:hostname]}/#{url.code}"
      end
      
      def generate_short_url(url = nil)
        code, result = nil, nil

        if !url.nil? && url != ""
          ff_url  = Firefly::Url.shorten(url)
          code    = ff_url.code
          result  = "http://#{config[:hostname]}/#{code}"
        end
        
        return code, result
      end
      
      def is_highlighted?(url)
        return false unless @highlight
        @highlight == url.code
      end
      
      # Format a tweet
      def tweet(url)
        config[:tweet].gsub('%short_url%', url)
      end
    end
    
    before do
      @authenticated = has_valid_api_cookie?
      @config        = config
      @highlight     = nil
      @title         = "Firefly &mdash; #{@config[:hostname]}"
    end
    
    get '/' do
      @highlight ||= Firefly::Url.first(:code => params[:highlight])
      @urls = Firefly::Url.all(:limit => config[:recent_urls], :order => [ :created_at.desc ])
      haml :index
    end
    
    post '/api/set' do
      if params[:api_key] == config[:api_key]
        puts "MATCH!"
        set_api_cookie(config[:api_key])
      else
        puts "NOT MATCH"
      end
      
      redirect '/'
    end
    
    # GET /add?url=http://ariejan.net&api_key=test
    # POST /add?url=http://ariejan.net&api_key=test
    #
    # Returns the shortened URL
    api_add = lambda {
      validate_api_permission
      @url           = params[:url]
      @code, @result = generate_short_url(@url)
      @result ||= "Invalid URL specified."
      
      if params[:visual]
        redirect "/?highlight=#{@code}"
      else
        @result
      end
    }
    
    get '/api/add', &api_add
    post '/api/add', &api_add
    
    # GET /b3d+
    #
    # Show info on the URL
    get '/api/info/:code' do
      validate_api_permission
      
      @url = Firefly::Url.first(:code => params[:code])
      
      if @url.nil?
        status 404
        "Sorry, that code is unknown."
      else
        @short_url = "http://#{config[:hostname]}/#{@url.code}"
        haml :info
      end
    end
    
    # GET /b3d
    #
    # Redirect to the shortened URL
    get '/:code' do
      @url = Firefly::Url.first(:code => params[:code])

      if @url.nil?
        status 404
        "Sorry, that code is unknown."
      else
        @url.register_click!
        redirect @url.url, 301
      end
    end
    
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
  end
end

