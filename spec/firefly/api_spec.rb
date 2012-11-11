require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "API" do
  include Rack::Test::Methods

  def app
    @@app
  end

  [:post, :get].each do |verb|
    describe "adding a URL by #{verb.to_s.upcase}" do
      it "should be okay adding a new URL" do
        self.send verb, '/api/add', url: 'http://example.org/', api_key: 'test'
        last_response.should be_ok
      end

      it "should return the shortened URL" do
        self.send verb, '/api/add', url: 'http://example.org/', api_key: 'test'
        url = Firefly::Url.where(url: "http://example.org/").first

        last_response.body.should eql("http://test.host/#{url.code}")
      end

      it "should generate a short code if `short` is blank" do
        self.send verb, '/api/add', url: "http://example.org", short: "", api_key: 'test'
        url = Firefly::Url.where(url: "http://example.org/").first

        last_response.should be_ok
        last_response.body.should eql("http://test.host/#{url.code}")
      end

      it "should permit including a requested short code" do
        self.send verb, '/api/add', url: "http://example.org", short: 'orz', api_key: 'test'

        last_response.should be_ok
        last_response.body.should eql("http://test.host/orz")
      end

      it "should not allow the same short code twice" do
        self.send verb, '/api/add', url: "http://example.org", short: 'orz', api_key: 'test'
        last_response.should be_ok
        self.send verb, '/api/add', url: "http://example.com", short: 'orz', api_key: 'test'
        last_response.should_not be_ok
      end

      it "should not allow short codes of size < 3" do
        self.send verb, '/api/add', url: "http://example.org", short: 'or', api_key: 'test'
        last_response.should_not be_ok
      end

      it "should not allow short codes of size > 64" do
        self.send verb, '/api/add', url: "http://example.org", short: 'x' * 65, api_key: 'test'
        last_response.should_not be_ok
      end

      it "should show an error when shortening an invalid URL" do
        self.send verb, '/api/add', url: 'ftp://example.org', api_key: 'test'
        last_response.body.should match("The URL you posted is invalid")
      end

      it "should show an error when shortening an invalid URL in visual mode" do
        self.send verb, '/api/add', url: 'ftp://example.org', api_key: 'test', visual: "1"
        last_response.body.should match("The URL you posted is invalid")
      end

      it "should redirect to the highlighted URL when visual is enabled" do
        self.send verb, '/api/add', url: 'http://example.org/', api_key: 'test', visual: "1"
        follow_redirect!

        last_request.path.should eql("/")
        last_request.should be_get
      end

      it "should store the API key in the session with visual enabled" do
        self.send verb, '/api/add', url: 'http://example.org/', api_key: 'test', visual: "1"
        follow_redirect!

        last_response.body.should_not match(/API Key/)
      end

      it "should highlight the shortened URL" do
        self.send verb, '/api/add', url: 'http://example.org/', api_key: 'test', visual: "1"
        url = Firefly::Url.where(url: "http://example.org/").first
        follow_redirect!

        last_request.query_string.should match(/highlight=#{url.code}/)
      end

      it "should return a 401 on a wrong API key" do
        self.send verb, '/api/add', url: 'http://example.org', api_key: 'false'
        last_response.status.should eql(401)
      end

      it "should not return a shortened URL on 401" do
        self.send verb, '/api/add', url: 'http://example.org', api_key: 'false'
        last_response.body.should match(/Permission denied: Invalid API key/)
      end

      it "should create a new Firefly::Url" do
        lambda {
          self.send verb, '/api/add', url: 'http://example.org/', api_key: 'test'
        }.should change(Firefly::Url, :count).by(1)
      end

      it "should not create the same Firefly::Url twice" do
        self.send verb, '/api/add', url: 'http://example.org', api_key: 'test'

        lambda {
          self.send verb, '/api/add', url: 'http://example.org', api_key: 'test'
        }.should_not change(Firefly::Url, :count).by(1)
      end
    end
  end

  describe "getting information" do
    before(:each) do
      @created_at = Time.now
      @url = Firefly::Url.create(url: 'http://example.com/123', code: 'alpha', clicks: 69, created_at: @created_at)
    end

    it "should work" do
      get '/api/info/alpha', api_key: "test"
      last_response.should be_ok
    end

    it "should show the click count" do
      get '/api/info/alpha', api_key: "test"
      last_response.body.should match(/69/)
    end

    it "should show the short URL" do
      get '/api/info/alpha', api_key: "test"
      last_response.body.should match(/alpha/)
    end

    it "should show the shortened at time" do
      get '/api/info/alpha', api_key: "test"
      last_response.body.should match(/#{@created_at.strftime("%Y-%m-%d %H:%M")}/)
    end

    it "should show the full URL" do
      get '/api/info/alpha', api_key: "test"
      last_response.body.should match(/http:\/\/example.com\/123/)
    end

    it "should validate API permissions" do
      get '/api/info/alpha', api_key: false
      last_response.status.should be(401)
    end
  end

  describe "api key" do
    def app
      Firefly::Server.new do
        set :hostname,    "test.host"
        set :api_key,     "test#!"
      end
    end

    it "should be okay adding a new URL" do
      self.send :get, '/api/add', url: 'http://example.org/api_key_test', api_key: 'test#!'
      last_response.should be_ok
    end
  end
end
