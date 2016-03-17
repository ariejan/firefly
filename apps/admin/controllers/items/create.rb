module Admin::Controllers::Items
  class Create
    include Admin::Action

    expose :item

    params do
      param :item do
        param :content, presence: true
      end
    end

    def call(params)
      @item = ItemRepository.create_from_url(params[:item][:content])
      redirect_to '/admin'
    end
  end
end
