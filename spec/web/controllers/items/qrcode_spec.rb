require 'spec_helper'
require_relative '../../../../apps/web/controllers/items/qrcode'

describe Web::Controllers::Items::Qrcode do
  let(:action) { Web::Controllers::Items::Qrcode.new }

  before do
    ItemRepository.clear
    @item = ItemRepository.create(Item.new(type: 'url', content: 'https://devroom.io'))
    @code = Base62.encode(@item.id)
  end

  it 'displays png' do
    response = action.call(Hash[code: @code])
    response[0].must_equal 200
    response[1]['Content-Type'].must_equal 'image/png; charset=utf-8'
    response[2][0][1..3].must_equal 'PNG'
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
