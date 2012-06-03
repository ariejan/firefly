require 'spec_helper'

describe UrlsController do
  context '#redirect' do
    context 'with a url' do
      let(:url) { create :url }

      before do
        get :redirect, fingerprint: url.fingerprint
      end

      it 'returns a 301' do
        response.status.should == 301
      end

      it 'sets the Location header' do
        response.headers["Location"].should == url.url
      end
    end

    context 'without a url' do
      it 'returns a 404' do
        get :redirect, fingerprint: 'asdf'
        response.status.should == 404
      end
    end
  end
end
