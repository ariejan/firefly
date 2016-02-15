module Api::Controllers::Items
  class Create
    include Api::Action

    def call(params)
      self.format = :text

      item = ItemRepository.create_from_url(params[:url])

      self.body = item.short_url
    end
  end
end
