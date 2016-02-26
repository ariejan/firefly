require 'spec_helper'
require_relative '../../../../apps/admin/views/dashboard/index'

describe Admin::Views::Dashboard::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/dashboard/index.html.erb') }
  let(:view)      { Admin::Views::Dashboard::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
