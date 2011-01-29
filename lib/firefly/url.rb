module Firefly
  class Url
    include DataMapper::Resource
    
    VALID_URL_REGEX  = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
    VALID_CODE_REGEX = /^[a-z0-9\-_]{3,64}$/i

    property :id,           Serial
    property :url,          String,     :index => true, :length => 255
    property :code,         String,     :index => true, :length => 64
    property :clicks,       Integer,    :default => 0
    property :created_at,   DateTime,   :default => Proc.new{Time.now}

    # Increase the visits counter by 1
    def register_click!
      self.update(:clicks => self.clicks + 1)
    end

    # Shorten a long_url and return a new FireFly::Url
    def self.shorten(long_url, code = nil)
      code = nil if code !~ /\S/

      return nil unless valid_url?(long_url)
      return nil unless valid_code?(code)

      long_url = normalize_url(long_url)

      the_url = Firefly::Url.first(:url => long_url) || Firefly::Url.create(:url => long_url)
      code ||= Firefly::Base62.encode(the_url.id.to_i)
      the_url.update(:code => code) if the_url.code.nil?
      the_url
    end

    private
      # Normalize the URL
      def self.normalize_url(url)
        URI.parse(URI.escape(url)).normalize.to_s
      end

      # Validates the URL to be a valid http or https one. 
      def self.valid_url?(url)
        url.match(Firefly::Url::VALID_URL_REGEX)
      end

      def self.valid_code?(code)
        return true if code.nil?
        code.match(Firefly::Url::VALID_CODE_REGEX) && Firefly::Url.count(:code => code) == 0
      end

  end
end
