require 'spec_helper'
require_relative '../../../../apps/admin/views/dashboard/index'

describe Admin::Views::Dashboard::Index do
  let(:exposures) { Hash[items: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/dashboard/index.html.haml') }
  let(:view)      { Admin::Views::Dashboard::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #items' do
    view.items.must_equal exposures.fetch(:items)
  end
end
