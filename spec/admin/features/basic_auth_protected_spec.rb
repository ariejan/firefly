require 'features_helper'

describe 'http basic auth protected' do

  def setup
    basic_authorize 'admin', 'password'
  end

  it 'does not grant access by default' do
    basic_authorize 'non-user', 'non-password'
    get '/admin'
    last_response.status.must_equal 401
  end

  it 'does grant access with username/password' do
    # basic_authorize 'admin', 'password'
    get '/admin'
    last_response.status.must_equal 200
  end

end
