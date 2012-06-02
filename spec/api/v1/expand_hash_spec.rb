require 'spec_helper'

describe '/api/v1/expand', type: :api do
  let(:api_url) { '/api/v1/expand' }

  context 'with a firefly available' do
    let(:url) { create :url }

    context "for a fingerprint" do
      it 'returns a 200' do
        get api_url, fingerprint: url.fingerprint
        last_response.status.should == 200
      end

      it 'returns correct json' do
        get api_url, fingerprint: url.fingerprint
        last_response.body.should be_json_eql %({"url" : "#{url.url}"})
      end
    end

    context "for a short url" do
      it 'returns a 200' do
        get api_url, fingerprint: "http://test.host/#{url.fingerprint}"
        last_response.status.should == 200
      end

      it 'returns correct json' do
        get api_url, fingerprint: "http://test.host/#{url.fingerprint}"
        last_response.body.should be_json_eql %({"url" : "#{url.url}"})
      end
    end
  end

  context 'with no url available' do
    context "for a fingerprint" do
      it 'returns a 404' do
        get api_url, fingerprint: 'abcdef'
        last_response.status.should == 404
      end
    end

    context "for a short url" do
      it 'returns a 404' do
        get api_url, fingerprint: 'http://test.host/abcdef'
        last_response.status.should == 404
      end
    end
  end
end
