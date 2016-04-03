require 'spec_helper'

describe ClickRepository do
  before do
    ItemRepository.clear
    ClickRepository.clear

    @item = ItemRepository.create(Item.new(type: 'url', content: "https://devroom.io/page"))
  end

  it 'records single clicks' do
    assert_equal 0, ClickRepository.clicks_for(@item)
    ClickRepository.register_for(@item)
    assert_equal 1, ClickRepository.clicks_for(@item)
  end

  it 'records multiple clicks' do
    assert_equal 0, ClickRepository.clicks_for(@item)
    ClickRepository.register_for(@item, 3)
    assert_equal 3, ClickRepository.clicks_for(@item)
  end
end
