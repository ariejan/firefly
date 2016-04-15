require 'spec_helper'

describe CreateItemFromURL do
  let(:url) { 'https://ariejan.net/about' }

  before do
    ItemRepository.clear
  end

  it 'creates a new item' do
    result = CreateItemFromURL.new(url).call

    result.item.id.wont_be_nil
    result.item.type.must_equal 'url'
    result.item.content.must_equal(url)
  end

  it 'handles duplicate items' do
    ItemRepository.count.must_equal(0)

    original  = CreateItemFromURL.new(url).call
    duplicate = CreateItemFromURL.new(url).call

    ItemRepository.count.must_equal(1)
    duplicate.item.id.must_equal(original.item.id)
  end

  it 'creates a job for retrieving HTML info' do
    LinkHtmlTitleWorker.expects(:perform_async).once
    CreateItemFromURL.new(url).call
  end
end
