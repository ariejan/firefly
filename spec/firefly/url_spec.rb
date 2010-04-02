require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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