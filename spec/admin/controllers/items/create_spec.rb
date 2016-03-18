require 'spec_helper'
require_relative '../../../../apps/admin/controllers/items/create'

describe Admin::Controllers::Items::Create do
  let(:url)    { 'http://test.host/' }
  let(:action) { Admin::Controllers::Items::Create.new }

  describe 'with valid params' do
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

  describe 'with invalid params' do
    let(:params) { Hash[item: {content: ""}] }

    it 're-renders the new view' do
      response = action.call(params)
      response[0].must_equal 200
    end

    it 'sets errors attributes' do
      action.call(params)
      refute action.params.valid?
      action.errors.for('item.content').wont_be_empty
    end
  end
end
