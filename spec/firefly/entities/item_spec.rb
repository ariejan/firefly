require 'spec_helper'

describe Item do

  before do
    ItemRepository.clear

    @item  = ItemRepository.create(Item.new(type: 'url', content: 'http://nu.nl'))
    @code  = Base62.encode(@item.id)

    ClickRepository.register_for(@item, 3)
  end

  it '#short_url' do
    @item.short_url.must_equal "http://test.host/#{@code}"
  end

  it '#short_url with SSL enabled' do
    ENV['FIREFLY_SSL_ENABLED'] = "true"
    @item.short_url.must_equal "https://test.host/#{@code}"
    ENV['FIREFLY_SSL_ENABLED'] = "false"
  end

  it '#code' do
    @item.code.must_equal(@code)
  end

  it '#number_of_clicks' do
    assert_equal 3, @item.number_of_clicks
  end

  it '#click!' do
    assert_equal 3, @item.number_of_clicks
    @item.click!
    assert_equal 4, @item.number_of_clicks
  end
end
