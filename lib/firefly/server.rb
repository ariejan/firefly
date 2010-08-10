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
          return false 
				else
					return true
        end
      end
      
      def short_url(url)
        "http://#{config[:hostname]}/#{url.code}"
      end
      
      def generate_short_url(url = nil)
        code, result = nil, nil

        if !url.nil? && url != ""
          ff_url  = Firefly::Url.shorten(url)
          if !ff_url.nil?
            code    = ff_url.code
            result  = "http://#{config[:hostname]}/#{code}"
          else
            code    = nil
            result  = "ERROR: The URL you posted is invalid."
          end
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
      
      def store_api_key(key)
        if key == config[:api_key]
          set_api_cookie(config[:api_key])
        end
      end
    end
    
    before do
      @authenticated = has_valid_api_cookie?
      @config        = config
      @highlight     = nil
      @title         = "Firefly &mdash; #{@config[:hostname]}"
    end
    
    get '/' do
      @highlight = Firefly::Url.first(:code => params[:highlight])
      @error     = params[:highlight] == "error"
      @urls = Firefly::Url.all(:limit => config[:recent_urls], :order => [ :created_at.desc ])
      haml :index
    end
    
    post '/api/set' do
      store_api_key(params[:api_key])
      redirect '/'
    end
    
    # GET /add?url=http://ariejan.net&api_key=test
    # POST /add?url=http://ariejan.net&api_key=test
    #
    # Returns the shortened URL
    api_add = lambda {
      validate_api_permission or return "Permission denied: Invalid API key"

      @url           = params[:url]
      @code, @result = generate_short_url(@url)
      @result ||= "Invalid URL specified."
      
      if params[:visual]
        store_api_key(params[:api_key])
        @code ||= "error"
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
      validate_api_permission or return "Permission denied: Invalid API key"

      @url = Firefly::Url.first(:code => params[:code])
      
      if @url.nil?
        status 404
        "Sorry, that code is unknown."
      else
        @short_url = "http://#{config[:hostname]}/#{@url.code}"
        haml :info
      end
    end
   
    # GET /api/export.csv
    #
    # Download a CSV file with all shortened URLs
    get '/api/export.csv' do
      @urls = Firefly::Url.all(:order => [ :created_at.asc ])

      output = "\"Code\",\"Short URL\",\"Long URL\",\"Clicks\",\"Created at\"\n"
      @urls.each do |url|
        output += "\"#{url.code}\",\"#{short_url(url)}\",\"#{url.url}\",\"#{url.clicks}\",\"#{url.created_at.strftime('%Y-%m-%d %H:%M:%S')}\"\n" 
      end

      attachment "firefly-export.csv"
      content_type "text/csv"
      output
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
        check_mysql_collation
      rescue
        puts "Error setting up database connection. Please check the `database` setting in config.ru"
				puts $!
				puts "-------"
				puts $!.backtrace
        exit(1)
      end
    end

		def check_mysql_collation(first_try = true)
			# Make sure the 'code' column is case-sensitive. This hack is for
			# MySQL only, other database systems don't have this problem. 
			if DataMapper.repository(:default).adapter =~ "DataMapper::Adapters::MysqlAdapter"
				query     = "SHOW FULL COLUMNS FROM firefly_urls WHERE Field='code';"
				collation = DataMapper.repository(:default).adapter.select(query)[0][:collation]

				if collation != "utf8_bin"
					if first_try
					  puts " ~ Your MySQL database is not using the 'utf8-bin' collation. Trying to fix..."
				    DataMapper.repository(:default).adapter.execute("ALTER TABLE firefly_urls MODIFY `code` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin;")
						return check_mysql_collation(false) 
					else
						puts " ~ Failed to set the collation for `code` in `firefly_urls`. Please see http://wiki.github.com/ariejan/firefly/faq for details."
						return false
					end
				else
					if !first_try
					  puts " ~ Successfully fixed your database."
					end
				  return true
				end
			end
		end
  end
end

