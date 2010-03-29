module Firefly
  class Url
    include DataMapper::Resource

    property :id,           Serial
    property :url,          String,     :index => true, :length => 255
    property :code,         String,     :index => true, :length => 255
    property :visits,       BigDecimal, :default => 0
    property :created_at,   DateTime,   :default => Time.now
    
    # Increase the visits counter by 1
    def visit!
      self.update(:visits => self.visits + 1)
    end
    
    # Encode a URL and return the encoded ID
    def self.encode(url)
    
      @result = self.first(:url => url)
    
      if @result.nil?
        @result = self.create(:url => url)
        @result.update(:code => Firefly::Base62.encode(@result.id.to_i))
      end
    
      return @result.code
    end
  
    # Decode a code to the original URL
    def self.decode(code)
      @result = Firefly::Url.first(:code => code)  
      return @result.nil? ? nil : @result
    end
  end
end
