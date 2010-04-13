module Firefly
  class Url
    include DataMapper::Resource

    property :id,           Serial
    property :url,          String,     :index => true, :length => 255
    property :code,         String,     :index => true, :length => 16
    property :clicks,       Integer,    :default => 0
    property :created_at,   DateTime,   :default => Proc.new{Time.now}
    
    # Increase the visits counter by 1
    def register_click!
      self.update(:clicks => self.clicks + 1)
    end
    
    # Shorten a long_url and return a new FireFly::Url
    def self.shorten(long_url)
      the_url = Firefly::Url.first(:url => long_url) || Firefly::Url.create(:url => long_url)
      the_url.update(:code => Firefly::Base62.encode(the_url.id.to_i)) if the_url.code.nil?
      the_url
    end  
  end
end
