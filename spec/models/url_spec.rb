require 'spec_helper'

describe Url do
  context 'fingerprint' do
    it 'sets the ID to fingerprint after_create' do
      url = Url.create(url: 'http://example.com')
      url.fingerprint.should == "#{url.id}"
    end
  end
end
