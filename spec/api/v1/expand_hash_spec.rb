require 'spec_helper'

describe '/api/v1/expand', type: :api do
  let(:url) { '/api/v1/expand' }

  context 'with no url available' do
    it 'returns a 404 for the hash' do
      get url, hash: 'abcdef'
      last_response.status.should == 404
    end

    it 'return a 404 for the full url' do
      get url, hash: 'http://test.host/abcdef'
      last_response.status.should == 404
    end
  end
end
