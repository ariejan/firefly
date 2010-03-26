require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require File.dirname(__FILE__) + '/spec_helper'

describe "FireFly" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
  
end
