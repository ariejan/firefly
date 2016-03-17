require 'spec_helper'
require_relative '../../../../apps/admin/controllers/items/create'

describe Admin::Controllers::Items::Create do
  let(:url)    { 'http://test.host/' }
  let(:action) { Admin::Controllers::Items::Create.new }
  let(:params) { Hash[item: {content: url}] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 302
    response[1]['Location'].must_equal '/admin'
  end

  it 'creates a new item' do
    action.call(params)

    action.item.id.wont_be_nil
    action.item.content.must_equal url
  end
end
