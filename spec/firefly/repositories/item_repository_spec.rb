require 'spec_helper'

describe ItemRepository do
  before do
    ItemRepository.clear
  end

  describe '.recent' do
    before do
      @item1 = ItemRepository.create_from_url("http://test.host/1")
      @item2 = ItemRepository.create_from_url("http://test.host/2")
    end

    it 'returns n most recent URLs' do
      result = ItemRepository.recent(1).all
      result.must_equal [@item2]

      result = ItemRepository.recent(3).all
      result.must_equal [@item2, @item1]
    end
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
