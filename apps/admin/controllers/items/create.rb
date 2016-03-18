module Admin::Controllers::Items
  class Create
    include Admin::Action

    expose :item

    params do
      param :item do
        param :content, presence: true, format: URI.regexp(['http', 'https'])
      end
    end

    def call(params)
      if params.valid?
        @item = ItemRepository.create_from_url(params[:item][:content])
        redirect_to '/admin'
      end
    end
  end
end
