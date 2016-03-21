require 'spec_helper'
require_relative '../../../../apps/admin/controllers/items/destroy'

describe Admin::Controllers::Items::Destroy do
  let(:action) { Admin::Controllers::Items::Destroy.new }
  let(:item) { ItemRepository.create(Item.new(type: 'url', content: "https://devroom.io/page")) }
  let(:params) { Hash[id: item.id] }

  it 'redirects to /admin' do
    response = action.call(params)
    response[0].must_equal 302
    response[1]['Location'].must_equal '/admin'
  end

  it 'deletes the item' do
    action.call(params)
    ItemRepository.find(params[:id]).must_be_nil
  end
end
