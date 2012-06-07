require 'spec_helper'

describe Url do
  context 'validations' do
    context 'valid' do
      urls = [
        "http://example.com",
        "https://example.org",
        "http://example.com/path",
        "http://example.com/sub/path/index.html",
        "http://example.com/?a=123&b=456",
        "http://example.com/sub/path/index with spaces.html"
      ]

      urls.each do |url|
        it { should allow_value(url).for(:url) }
      end
    end

    context 'invalid' do
      urls = [
        "ftp://example.com",
        "gopher://example.org"
      ]

      urls.each do |url|
        it { should_not allow_value(url).for(:url) }
      end
    end
  end

  context 'fingerprint' do
    it 'sets the ID to fingerprint after_create' do
      url = Url.create(url: 'http://example.com')
      url.fingerprint.should == "#{url.id}"
    end
  end
end
