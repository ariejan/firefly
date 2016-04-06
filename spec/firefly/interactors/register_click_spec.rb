require 'spec_helper'

describe RegisterClick do
  before do
    ItemRepository.clear
    @item = url_item
  end

  it 'handles duplicate items' do
    ClickRepository.count_for(@item).must_equal(0)
    RegisterClick.new(@item).call
    ClickRepository.count_for(@item).must_equal(1)
  end
end

