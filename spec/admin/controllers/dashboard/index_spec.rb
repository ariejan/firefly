require 'spec_helper'
require_relative '../../../../apps/admin/controllers/dashboard/index'

describe Admin::Controllers::Dashboard::Index do
  let(:action) { Admin::Controllers::Dashboard::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
