require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Url" do
  
  describe "shortening" do
    
    it "should generate a hash after create" do
      url = Firefly::Url.shorten("http://example.com/")
      url.hash.should_not be_nil
    end
    
    it "should set a clicks count of 0 for newly shortened urls" do
      url = Firefly::Url.shorten("http://example.com/")
      url.clicks.should eql(0)
    end
    
    it "should create a new Firefly::Url with a new long_url" do
      lambda {
        Firefly::Url.shorten("http://example.com/")
      }.should change(Firefly::Url, :count).by(1)
    end
    
    it "should return an existing Firefly::Url if the long_url exists" do
      Firefly::Url.shorten("http://example.com/")
      lambda {
        Firefly::Url.shorten("http://example.com/")
      }.should_not change(Firefly::Url, :count)
    end
  end
  
  describe "clicking" do
    before(:each) do
      Firefly::Url.create(
        :url => 'http://example.com/123', 
        :hash => 'alpha', 
        :clicks => 69
      )
      @url = Firefly::Url.first(:hash => 'alpha')
    end
    
    it "should increase the click count" do
      lambda {
        @url.register_click!
      }.should change(@url, :clicks).by(1)
    end
  end
end