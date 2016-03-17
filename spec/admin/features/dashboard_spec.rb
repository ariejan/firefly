require 'features_helper'

describe 'dashboard' do
  before do
    ItemRepository.clear

    @items = []
    10.times do |n|
      @items << ItemRepository.create(Item.new(type: 'url', content: "https://devroom.io/page-#{n}"))
    end

    basic_auth('admin', 'password')
  end

  it 'shows the 10 last shortened URLs' do
    visit '/admin'

    within '#recent' do
      @items.each do |item|
        within "#item_#{item.id}" do
          assert page.has_link?(item.short_url)
          assert page.has_link?(item.content)
        end
      end
    end
  end

  it 'allows to shorten an URL directly' do
    basic_auth('admin', 'password')
    visit '/admin'

    url = 'http://example.com/test_this'

    fill_in 'item-content', with: url
    click_button 'Shorten'

    within '#recent' do
      assert page.has_link?(url)
    end
  end
end
