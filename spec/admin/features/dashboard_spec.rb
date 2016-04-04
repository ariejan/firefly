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

  it 'handles incorrect input correctly' do
    basic_auth('admin', 'password')
    visit '/admin'

    url = 'skype:adevroom?call'

    fill_in 'item-content', with: url
    click_button 'Shorten'

    assert page.has_text?("That does not look like a valid URL!")
  end

  it 'handles no input correctly' do
    basic_auth('admin', 'password')
    visit '/admin'

    click_button 'Shorten'

    assert page.has_text?("Please enter a valid URL")
  end

  it 'shows item statistics' do
    @item = @items[3]
    ClickRepository.register_for(@item, 3)

    basic_auth('admin', 'password')
    visit '/admin'

    within("#item_#{@item.id} .statistics") do
      assert page.has_text?("3")
    end
  end

  describe 'deletion of an item' do
    before do
      @item = @items[2]
    end

    it 'works correctly' do
      basic_auth('admin', 'password')
      visit '/admin'

      within('#recent') do
        assert page.has_selector?('.item', count: 10)
      end

      within("#item_#{@item.id}") do
        click_link "delete_item_#{@item.id}"
      end

      within('#recent') do
        assert page.has_selector?('.item', count: 9)
      end
    end
  end

  it 'links to png QR code' do
    basic_auth('admin', 'password')
    visit '/admin'

    within("#item_#{@items[7].id}") do
      click_link "item_qrcode_#{@items[7].id}"
    end

    assert page.status_code.must_equal 200
  end
end
