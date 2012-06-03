require 'spec_helper'

describe '/api/v1/shorten', type: :api do
  let(:api_url) { '/api/v1/shorten' }

  context 'a valid longUrl' do
    let(:long_url) { 'http://example.com' }

    before do
      post api_url, long_url: long_url
    end

    it 'returns status 200' do
      last_response.status.should == 200
    end

    it 'returns a short URL' do
      the_url = Url.last
      expected_json = %({
        "fingerprint" : "#{the_url.fingerprint}",
        "url" : "http://#{Settings.host}/#{the_url.fingerprint}"
      })
      last_response.body.should be_json_eql expected_json
    end
  end
end
