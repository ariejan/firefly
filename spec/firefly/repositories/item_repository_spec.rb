require 'spec_helper'

describe ItemRepository do
  before do
    ItemRepository.clear

    @item1 = url_item("http://test.host/1", created_at: Date.parse("2015-02-24").to_time)
    @item2 = url_item("http://test.host/2", created_at: Date.parse("2015-07-05").to_time)
  end

  describe '.recent' do
    it 'returns n most recent URLs' do
      result = ItemRepository.recent(1).all
      result.must_equal [@item2]

      result = ItemRepository.recent(3).all
      result.must_equal [@item2, @item1]
    end
  end

  describe '.find_by_content' do
    it 'returns an item with known content' do
      result = ItemRepository.find_by_content(@item2)
      result.must_equal @item2
    end
  end

  describe '.count' do
    it 'returns number of items' do
      ItemRepository.count.must_equal(2)
    end
  end
end
