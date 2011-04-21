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
      :target => 'twitter',
      :title  => 'Test post'
    }
  end

  [:post, :get].each do |verb|
    describe "twitter" do
      it "should create a shortened URL" do
        lambda {
          self.send verb, '/api/share', @params
        }.should change(Firefly::Url, :count).by(1)
      end

      it "should redirect to twitter with status" do
        self.send verb, '/api/share', @params
        last_response.should be_redirect
        last_response['Location'].should match(/twitter.com/i)
      end

      it "should post the title and short url to twitter" do
        self.send verb, '/api/share', @params
        url = Firefly::Url.first(:url => @params[:url])

        last_response['Location'].should include(URI.escape("#{@params[:title]} http://test.host/#{url.code}"))
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

      it "should shorten long titles to fit within the 140 character limit" do
        title = "This is a very long title that will never fit in the current one hundred and forty character limit enforce by twitter. Or does it?"
        self.send verb, '/api/share', @params.merge(:title => title)
        url = Firefly::Url.first(:url => @params[:url])

        short_url = "http://test.host/#{url.code}"
        expected  = title.slice(0...(140-1-short_url.length)) + ' ' + short_url

        last_response['Location'].should include(URI.escape(expected))
      end

      it "should strip the title to remove any unnecessary white space" do
        title = "      Test post        "
        self.send verb, '/api/share', @params.merge(:title => title)
        url = Firefly::Url.first(:url => @params[:url])

        last_response['Location'].should include(URI.escape("Test post http://test.host/#{url.code}"))
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
