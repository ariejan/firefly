require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Firefly" do
  describe "home page" do
    it "should redirect when not logged in" do
      get '/'
      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should include '/login'
    end

    it "should redirect when invalid parameters" do
      post '/api/set', { "api_key" => "not_the_right_key"}

      get '/'
      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should include '/login'
    end

    it "should be able to login" do
      post '/api/set', { "api_key" => "test"}
      follow_redirect!
      last_response.should be_ok

      get '/'
      last_response.should be_ok
    end
  end


  if defined? Barby
    describe "QR Codes" do
      before(:each) do
        @url = Firefly::Url.create(url: 'http://example.com/123', code: 'alpha')
      end

      it "should return a 200 status" do
        get '/alpha.png'
        last_response.should be_ok
      end

      it "should return a PNG image" do
        get '/alpha.png'
        last_response.headers['Content-Type'].should eql('image/png')
      end

      it "should cache-control to 1 month" do
        get '/alpha.png'
        last_response.headers['Cache-Control'].should eql('public, max-age=2592000')
      end
    end
  end

  describe "redirecting" do
    it "should redirect to the original URL" do
      fake = Firefly::Url.create(url: 'http://example.com/123', code: 'alpha')

      get '/alpha'
      follow_redirect!

      last_request.url.should eql('http://example.com/123')
    end

    it "should increase the visits counter" do
      url = Firefly::Url.create(url: 'http://example.com/123', code: 'alpha')

      lambda {
        get '/alpha'
      }.should change { url.reload.clicks }.by(1)
    end

    it "should redirect with a 301 Permanent redirect" do
      fake = Firefly::Url.create(url: 'http://example.com/123', code: 'alpha')

      get '/alpha'

      last_response.status.should eql(301)
    end

    it "should throw a 404 when the code is unknown" do
      get '/some_random_code_that_does_not_exist'

      last_response.status.should eql(404)
    end
  end
end
