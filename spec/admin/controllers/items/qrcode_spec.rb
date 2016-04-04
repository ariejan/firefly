require 'spec_helper'
require_relative '../../../../apps/admin/controllers/items/qrcode'

describe Admin::Controllers::Items::Qrcode do
  let(:action) { Admin::Controllers::Items::Qrcode.new }
  let(:item) { ItemRepository.create(Item.new(type: 'url', content: "https://devroom.io/page")) }
  let(:params) { Hash[id: item.id] }

  it 'displays png' do
    response = action.call(params)
    response[0].must_equal 200
    response[1]['Content-Type'].must_equal 'image/png; charset=utf-8'
    response[2][0][1..3].must_equal 'PNG'
  end
end
