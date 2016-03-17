module Api::Controllers::Items
  class Create
    include Api::Action

    # TODO: Validate params

    def call(params)
      self.format = :text

      item = ItemRepository.create_from_url(params[:url])

      self.body = item.short_url
    end
  end
end
