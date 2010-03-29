require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require File.dirname(__FILE__) + '/spec_helper'

describe "Firefly" do
  include Rack::Test::Methods

  def app
    @@app
  end
  
  describe "/" do
    it "should respond ok" do
      get '/'
      last_response.should be_ok
    end
  end
  
  describe "Url" do
    before(:each) do
      @url = Firefly::Url.create(:url => 'http://example.com/123', :code => 'alpha')
    end
    
    it "should set a created_at timestamp" do
      @url.created_at.should_not be_nil
    end
    
    it "should have a visit count of 0 by default" do      
      @url.visits.should eql(0)
    end
    
    it "should increase visits when calling visit!" do
      lambda {
        @url.visit!
      }.should change(@url, :visits).by(1)
    end
  end
  
  describe "adding a URL" do
    it "should be okay adding a new URL" do
      post '/api/add', :url => 'http://example.org', :api_key => 'test'
      last_response.should be_ok
    end
    
    it "should return the shortened URL" do
      post '/api/add', :url => 'http://example.org', :api_key => 'test'
      
      url = Firefly::Url.first(:url => "http://example.org")
      
      last_response.body.should eql("http://test.host/#{url.code}")
    end
    
    it "should return a 401 on a wrong API key" do
      post '/api/add', :url => 'http://example.org', :api_key => 'false'
      last_response.status.should eql(401)
    end
    
    it "should create a new Firefly::Url" do
      lambda {
        post '/api/add', :url => 'http://example.org', :api_key => 'test'
      }.should change(Firefly::Url, :count).by(1)
    end
  
    it "should not create the same Firefly::Url twice" do
      post '/api/add', :url => 'http://example.org', :api_key => 'test'
    
      lambda {
        post '/api/add', :url => 'http://example.org', :api_key => 'test'
      }.should_not change(Firefly::Url, :count).by(1)    
    end
  end
  
  describe "Base62 encoding/decoding" do
    [
      [        1,     "1"],
      [       10,     "a"],
      [       61,     "Z"],
      [       62,    "10"],
      [       63,    "11"],
      [      124,    "20"],
      [200000000, "dxb8s"]
    ].each do |input, output|
      it "should encode #{input} correctly to #{output}" do
        Firefly::Base62.encode(input).should eql(output)
      end
      
      it "should decode correctly" do
        Firefly::Base62.decode(output).should eql(input)
      end
    end
  end
  
  describe "getting information" do
    before(:each) do
      @created_at = Time.now
      @url = Firefly::Url.create(:url => 'http://example.com/123', :code => 'alpha', :visits => 69, :created_at => @created_at)
    end
    
    it "should work" do
      get '/api/info/alpha', :api_key => "test"
      last_response.should be_ok
    end
    
    it "should show the visit count" do
      get '/api/info/alpha', :api_key => "test"
      last_response.body.should match(/69/)
    end
        
    it "should show the short URL" do
      get '/api/info/alpha', :api_key => "test"
      last_response.body.should match(/alpha/)
    end
    
    it "should show the shortened at time" do
      get '/api/info/alpha', :api_key => "test"
      last_response.body.should match(/#{@created_at.strftime("%Y-%m-%d %H:%M")}/)
    end
    
    it "should show the full URL" do
      get '/api/info/alpha', :api_key => "test"
      last_response.body.should match(/http:\/\/example.com\/123/)
    end
    
    it "should validate API permissions" do
      get '/api/info/alpha', :api_key => false
      last_response.status.should be(401)
    end
  end
  
  describe "redirecting" do
    it "should redirect to the original URL" do
      fake = Firefly::Url.create(:url => 'http://example.com/123', :code => 'alpha')
    
      get '/alpha'
      follow_redirect!
    
      last_request.url.should eql('http://example.com/123')
    end
    
    it "should increase the visits counter" do
      fake = Firefly::Url.create(:url => 'http://example.com/123', :code => 'alpha')
      Firefly::Url.should_receive(:decode).and_return(fake)
      
      lambda {
        get '/alpha'
      }.should change(fake, :visits).by(1)
    end
    
    it "should redirect with a 301 Permanent redirect" do
      fake = Firefly::Url.create(:url => 'http://example.com/123', :code => 'alpha')
    
      get '/alpha'
    
      last_response.status.should eql(301)
    end
  
    it "should throw a 404 when the code is unknown" do
      get '/some_random_code_that_does_not_exist'
    
      last_response.status.should eql(404)
    end
  end
end
