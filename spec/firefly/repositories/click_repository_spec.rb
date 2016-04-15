require 'spec_helper'

describe ClickRepository do
  before do
    ItemRepository.clear
    ClickRepository.clear

    @item = ItemRepository.create(Item.new(type: 'url', content: "https://devroom.io/page"))
  end

  it 'records clicks' do
    assert_equal 0, ClickRepository.count_for(@item)
    ClickRepository.persist(Click.new(item_id: @item.id))
    assert_equal 1, ClickRepository.count_for(@item)
  end
end
