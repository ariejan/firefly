require 'spec_helper'
require_relative '../../../../apps/admin/controllers/dashboard/index'

describe Admin::Controllers::Dashboard::Index do
  let(:action) { Admin::Controllers::Dashboard::Index.new }
  let(:params) { Hash[] }

  before do
    ItemRepository.clear
    @item = ItemRepository.create_from_url('http://test.host')
  end

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end

  it 'exposes recent items' do
    action.call(params)
    action.exposures[:items].must_equal [@item]
  end
end
