# encoding: UTF-8
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

      raise Firefly::InvalidUrlError.new unless valid_url?(long_url)
      raise Firefly::InvalidCodeError.new unless valid_code?(code)

      long_url = normalize_url(long_url)

      the_url = Firefly::Url.first(:url => long_url) || Firefly::Url.create(:url => long_url)
      return the_url unless the_url.code.nil?

      code ||= get_me_a_code
      the_url.update(:code => code)
      the_url
    end

    private

      # Generate a unique code, not already in use.
      def self.get_me_a_code
        code = Firefly::CodeFactory.next_code!

        if Firefly::Url.count(:code => code) > 0 
          code = get_me_a_code
        end

        code
      end

      # Normalize the URL
      def self.normalize_url(url)
        url = URI.escape(URI.unescape(url))
        URI.parse(url).normalize.to_s
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
