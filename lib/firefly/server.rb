# encoding: UTF-8
require 'sinatra/base'
require 'haml'
require 'digest/md5'

module Firefly
  class InvalidUrlError < StandardError
  end

  class InvalidCodeError < StandardError
  end

  class Server < Sinatra::Base
    enable :sessions

    if Firefly.environment == "development"
      enable :logging, :dump_errors, :raise_errors
    end

    dir = File.join(File.dirname(__FILE__), '..', '..')

    set :views,   "#{dir}/views"
    set :public,  "#{dir}/public"
    set :haml,    {:format => :html5 }
    set :static,  true
    set :session_secret, nil

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

      # Taken from Rails
      def truncate(text, length, options = {})
        options[:omission] ||= "..."

        length_with_room_for_omission = length - options[:omission].length
        chars = text
        stop = options[:separator] ?
          (chars.rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission) : length_with_room_for_omission

        (chars.length > length ? chars[0...stop] + options[:omission] : text).to_s
      end

      def has_valid_api_cookie?
        key = session["firefly_session"]
        key == Digest::MD5.hexdigest(config[:api_key])
      end

      def has_valid_share_key?
        return false unless @config.has_key?(:sharing_key)
        @config[:sharing_key] == params[:key]
      end

      def has_valid_share_domain?
        return false unless @config.has_key?(:sharing_domains)
        return true if @config[:sharing_domains].empty?
        @config[:sharing_domains].any? { |domain| params[:url].include?(domain) }
      end

      def has_valid_share_target?
        return false unless @config.has_key?(:sharing_domains)
        @config[:sharing_targets].include?(params[:target].downcase.to_sym)
      end

      def validate_share_permission
        if has_valid_share_key? && has_valid_share_domain? && has_valid_share_target?
          return true
        else
          status 401
          return false
        end
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

      def generate_short_url(url = nil, requested_code = nil)
        code, result = nil, nil

        begin
          ff_url  = Firefly::Url.shorten(url, requested_code)
          code, result = ff_url.code, "http://#{config[:hostname]}/#{ff_url.code}"
        rescue Firefly::InvalidUrlError
          code, result = nil, "ERROR: The URL you posted is invalid."
        rescue Firefly::InvalidCodeError
          code, result = nil, "ERROR: The code is invalid or already exists."
        rescue
          code, result = nil, "ERROR: An unknown error occured"
        end

        return code, result
      end

      def is_highlighted?(url)
        return false unless @highlight
        @highlight == url.code
      end

      # Format a tweet
      #
      # redirect(URI.escape("http://twitter.com/home?status=#{tweet("http://#{config[:hostname]}/#{@code}", params[:title])}"))
      def tweet(url, message = nil)
        if message.nil? || message == ""
          config[:tweet].gsub('%short_url%', url)
        else
          max_length = 140-1-url.size
          [message.strip.slice(0...max_length), url].join(' ')
        end
      end

      # Format a hyves post
      # {"http://www.hyves.nl/profielbeheer/toevoegen/tips/?name=#{name_of_titel}&text=#{tekst_met_url)}&type=12&rating=5"
      def hyves_post(url, title = nil, body = nil)
        if title.nil? || title == ""
          title = config[:hyves_title]
        end

        if body.nil? || body == ""
          body = config[:hyves_body].gsub('%short_url%', url)
        end

        return "name=#{title.strip}&text=#{body.strip}&type=12&rating=5"
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
      @title         = "Firefly at http://#{@config[:hostname]}"

      set :session_secret, @config[:session_secret]
    end

    get '/' do
      @highlight = Firefly::Url.first(:code => params[:highlight])
      @error     = params[:highlight] == "error"

      sort_column = params[:s] || 'created_at'
      sort_order  = params[:d] || 'desc'

      @urls = Firefly::Url.all(:limit => config[:recent_urls], :order => [ sort_column.to_sym.send(sort_order.to_sym) ] )

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

      @url            = params[:url]
      @requested_code = params[:short]
      @code, @result  = generate_short_url(@url, @requested_code)
      invalid = @code.nil?

      if params[:visual]
        store_api_key(params[:api_key])
        @code.nil? ? haml(:error) : redirect("/?highlight=#{@code}")
      else
        head 422 if invalid
        @result
      end
    }

    get '/api/add', &api_add
    post '/api/add', &api_add

    api_share = lambda {
      validate_share_permission or return "Cannot share that URL."

      @url = params[:url]
      @code, @result = generate_short_url(@url, nil)
      invalid = @code.nil?

      params[:title] ||= ""
      title = URI.unescape(params[:title])

      case (params[:target].downcase.to_sym)
        when :twitter
          redirect(URI.escape("http://twitter.com/home?status=#{tweet("http://#{config[:hostname]}/#{@code}", title)}"))
        when :hyves
          redirect(URI.escape("http://www.hyves.nl/profielbeheer/toevoegen/tips/?#{hyves_post("http://#{config[:hostname]}/#{@code}", title)}"))
        when :facebook
          redirect(URI.escape("http://www.facebook.com/share.php?u=http://#{config[:hostname]}/#{@code}"))
        end
    }

    get '/api/share', &api_share
    post '/api/share', &api_share

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

    if defined? Barby
      # GET /b3d.png
      #
      # Return a QR code image
      get '/:code.png' do
        @url = Firefly::Url.first(:code => params[:code])

        if @url.nil?
          status 404
          "Sorry, that code is unknown."
        else
          qr = Barby::QrCode.new(short_url(@url))
          content_type('image/png')
          cache_control :public, :max_age => 2592000 # One month
          body(qr.to_png(:xdim => 15, :margin => 30))
        end
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
        check_mysql_collation
        check_code_factory
      rescue
        puts "Error setting up database connection. Please check the `database` setting in config.ru"
        puts $!
        puts "-------"
        puts $!.backtrace
        exit(1)
      end
    end

    def check_code_factory
      Firefly::CodeFactory.first || Firefly::CodeFactory.create(:count => 0)
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

