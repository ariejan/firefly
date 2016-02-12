require 'spec_helper'
require_relative '../../../../apps/web/views/items/resolver'

describe Web::Views::Items::Resolver do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/items/resolver.html.erb') }
  let(:view)      { Web::Views::Items::Resolver.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
