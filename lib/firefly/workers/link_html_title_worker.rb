class LinkHtmlTitleWorker
  include Sidekiq::Worker
  require 'open-uri'
  require 'nokogiri'

  def perform(item_id)
  	item = ItemRepository.find(item_id)

  	open(item.content) do |f|
  	  doc = Nokogiri::HTML(f)
  	  title = doc.at_css('title').text
  	  item.title = title
  	end

  	ItemRepository.update(item)
  end
end