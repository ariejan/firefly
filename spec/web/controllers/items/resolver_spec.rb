require 'spec_helper'
require_relative '../../../../apps/web/controllers/items/resolver'

describe Web::Controllers::Items::Resolver do
  let(:action) { Web::Controllers::Items::Resolver.new }
  let(:params) { Hash[code: 'b33f'] }

  before do
    ItemRepository.clear
    @item = ItemRepository.create(Item.new(code: 'b33f', type: 'url', content: 'https://devroom.io'))
  end

  it 'is permanent redirect' do
    response = action.call(params)
    response[0].must_equal 301
    response[1]['Location'].must_equal 'https://devroom.io'
  end
end
