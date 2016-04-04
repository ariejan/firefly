require 'features_helper'

describe 'Shorten URL' do
  let(:url) { 'https://ariejan.net/about' }

  before do
    ItemRepository.clear
  end

  it 'denies access without proper API token' do
    get '/api/v1/shorten', token: 'no-token', url: url
    last_response.status.must_equal 401
  end

  it 'returns response in TXT format' do
    get '/api/v1/shorten', token: 'token', url: url

    last_response.status.must_equal 200
    last_response.header["Content-Type"].must_equal 'text/plain; charset=utf-8'

    item = ItemRepository.last
    code = Base62.encode(item.id)

    last_response.body.must_equal item.short_url
  end

  it 'returns error with no url' do
    get '/api/v1/shorten', token: 'token'

    last_response.status.must_equal 400
    last_response.header["Content-Type"].must_equal 'text/plain; charset=utf-8'
    last_response.body.must_equal 'Invalid parameters'
  end

  it 'returns error with invalid url' do
    get '/api/v1/shorten', token: 'token', url: 'skype:adevroom'

    last_response.status.must_equal 400
    last_response.header["Content-Type"].must_equal 'text/plain; charset=utf-8'
    last_response.body.must_equal 'Invalid parameters'
  end

end
