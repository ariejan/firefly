module Api::Controllers::Items
  class Create
    include Api::Action

    params do
      param :token
      param :url, presence: true, format: URI.regexp(['http', 'https'])
    end

    def call(params)
      self.format = :text

      if params.valid?
        item = ItemRepository.create_from_url(params[:url])
        self.body = item.short_url
      else
        self.status = 400
        self.body   = "Invalid parameters"
      end
    end
  end
end
