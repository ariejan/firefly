require 'spec_helper'

describe ItemRepository do
  before do
    ItemRepository.clear
  end

  describe '.create_from_url' do
    let(:url) { 'https://ariejan.net/about' }

    it 'creates a new item' do
      item = ItemRepository.create_from_url(url)

      item.id.wont_be_nil
      item.type.must_equal 'url'
      item.content.must_equal url
    end

    it 'duplicate items' do
      item = ItemRepository.create_from_url(url)
      duplicate = ItemRepository.create_from_url(url)

      duplicate.id.must_equal(item.id)
    end
  end
end
