require 'spec_helper'
require_relative '../../../../apps/api/views/items/create'

describe Api::Views::Items::Create do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/api/templates/items/create.html.erb') }
  let(:view)      { Api::Views::Items::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
