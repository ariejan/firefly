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
        result = CreateItemFromURL.new(params[:item][:content]).call
        @item = result.item

        redirect_to '/admin'
      end
    end
  end
end
