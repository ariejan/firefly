require 'hanami/interactor'

class CreateItemFromURL
  include Hanami::Interactor
  expose :url, :item

  def initialize(url)
    @url = url
    @item = Item.new(content: url, type: 'url')
  end

  def call
    ItemRepository.transaction do
      @item = ItemRepository.find_by_content(@item) || ItemRepository.persist(@item)
      LinkHtmlTitleWorker.perform_async(@item.id)
    end
  end
end
