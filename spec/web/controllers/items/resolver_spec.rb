require 'spec_helper'
require_relative '../../../../apps/web/controllers/items/resolver'

describe Web::Controllers::Items::Resolver do
  let(:action) { Web::Controllers::Items::Resolver.new }

  before do
    ItemRepository.clear
    @item = ItemRepository.create(Item.new(type: 'url', content: 'https://devroom.io'))
    @code = Base62.encode(@item.id)
  end

  it 'is permanent redirect' do
    response = action.call(Hash[code: @code])
    response[0].must_equal 301
    response[1]['Location'].must_equal 'https://devroom.io'
  end

  it 'has correct Cache-Control headers' do
    response = action.call(Hash[code: @code])
    response[1]['Cache-Control'].must_equal 'private, max-age=90'
  end

  it 'records as a click' do
    ClickRepository.expects(:register_for).with(@item).once
    action.call(Hash[code: @code])
  end
end
