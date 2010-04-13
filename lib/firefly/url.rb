module Firefly
  class Url
    include DataMapper::Resource

    property :id,           Serial
    property :url,          String,     :index => true, :length => 255
    property :hash,         String,     :index => true, :length => 16
    property :clicks,       Integer,    :default => 0
    property :created_at,   DateTime,   :default => Time.now
    
    # After create, generate the Base62 hash
    after :create do
      update(:hash => Firefly::Base62.encode(self.id.to_i))
    end
    
    # Increase the visits counter by 1
    def register_click!
      self.update(:clicks => self.clicks + 1)
    end
    
    # Shorten a long_url and return a new FireFly::Url
    def self.shorten(long_url)
      Firefly::Url.first(:url => long_url) || Firefly::Url.create(:url => long_url)
    end  
  end
end
