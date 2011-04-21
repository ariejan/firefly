# encoding: UTF-8
# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Sharing" do
  include Rack::Test::Methods

  def app
    @@app
  end

  before(:each) do
    @params = {
      :url    => 'http://example.com/test',
      :key    => 'asdfasdf',
      :target => 'hyves',
      :title  => 'Test post'
    }
  end

  [:post, :get].each do |verb|
    describe "hyves" do
      it "should create a shortened URL" do
        lambda {
          self.send verb, '/api/share', @params
        }.should change(Firefly::Url, :count).by(1)
      end

      it "should redirect to hyves with status" do
        self.send verb, '/api/share', @params
        last_response.should be_redirect
        last_response['Location'].should match(/hyves.nl/i)
      end

      it "should post the title to hyves" do
        self.send verb, '/api/share', @params
        url = Firefly::Url.first(:url => @params[:url])
        last_response['Location'].should include(URI.escape("#{@params[:title]}"))
      end

      it "should post the title and short url to hyves" do
        self.send verb, '/api/share', @params
        url = Firefly::Url.first(:url => @params[:url])
        last_response['Location'].should include(URI.escape("http://test.host/#{url.code}"))
      end

      it "should not allow sharing of example.org URL" do
        self.send verb, '/api/share', @params.merge(:url => 'http://example.org/test123')
        last_response.status.should eql(401)
        last_response.body.should match(/cannot share that URL/i)
      end

      it "should not create a short URL for example.org URL" do
        lambda {
          self.send verb, '/api/share', @params.merge(:url => 'http://example.org/test123')
        }.should_not change(Firefly::Url, :count)
      end

      it "should not share to unknown target" do
        self.send verb, '/api/share', @params.merge(:target => 'twitterbook')
        last_response.status.should eql(401)
        last_response.body.should match(/cannot share that URL/i)
      end

      it "should not create a short URL for unknown target" do
        lambda {
          self.send verb, '/api/share', @params.merge(:target => 'twitterbook')
        }.should_not change(Firefly::Url, :count)
      end

      it "should strip the title to remove any unnecessary white space" do
        title = "      Test post        "
        self.send verb, '/api/share', @params.merge(:title => title)
        url = Firefly::Url.first(:url => @params[:url])

        last_response['Location'].should include(URI.escape("Test post"))
        last_response['Location'].should_not include(URI.escape(title))
      end

      it "should strip the body to remove any unnecessary white space" do
        title = "      This is the test body        "
        self.send verb, '/api/share', @params.merge(:title => title)
        url = Firefly::Url.first(:url => @params[:url])

        last_response['Location'].should include(URI.escape("http://test.host/#{url.code}"))
        last_response['Location'].should_not include(URI.escape(title))
      end


      it "should escape UTF-8 correctly" do
        title = "Chávez"
        self.send verb, '/api/share', @params.merge(:title => title)
        url = Firefly::Url.first(:url => @params[:url])

        last_response['Location'].should include("Ch%C3%A1vez")
        last_response['Location'].should_not include("Ch%E1vez")
      end
    end
  end
end
