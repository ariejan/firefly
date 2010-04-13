require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "API" do
  include Rack::Test::Methods

  def app
    @@app
  end
  
  describe "/v1/shorten" do
    before(:each) do
      @params = {
        :long_url => "http://example.com/long_url",
        :api_key => "test"
      }
    end
    
    it "should respond in json by default"
    it "should respond in json"
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
end
