require 'spec_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!
# Sidekiq::Testing.inline!

describe LinkHtmlTitleWorker do
  before :each do
    LinkHtmlTitleWorker.jobs.clear

    @item = ItemRepository.create(Item.new(type: 'url', content: "http://www.example.com/"))
  end

  it 'pushes jobs to queue' do
    assert_equal 0, LinkHtmlTitleWorker.jobs.size
    LinkHtmlTitleWorker.perform_async(@item.id)
    assert_equal 1, LinkHtmlTitleWorker.jobs.size
  end

  it 'gets title of page and updates Item' do
    assert_equal nil, @item.title
    LinkHtmlTitleWorker.new.perform(@item.id)
    assert_equal "Example Domain", ItemRepository.find(@item.id).title
  end
end
