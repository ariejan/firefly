require 'spec_helper'

describe FingerprintParser do
  subject { FingerprintParser }

  context '#extract_fingerprint' do
    context 'with no elements' do
      it 'return nil' do
        subject.extract_fingerprint.should be_nil
      end
    end

    context 'with on element' do
      it 'returns the element' do
        subject.extract_fingerprint('meh').should == 'meh'
      end

      it 'returns nil if the element is blank' do
        subject.extract_fingerprint('').should be_nil
      end

      it 'returns the fingerprint from a short_url' do
        subject.extract_fingerprint('http://test.host/abcdef').should == 'abcdef'
      end
    end

    context 'with N elements' do
      it 'returns the first non-blank element' do
        subject.extract_fingerprint('', 'meh').should == 'meh'
      end

      it 'returns the fingerprint from the url' do
        subject.extract_fingerprint(nil, 'http://test.host/abcdef').should == 'abcdef'
      end
    end
  end
end
