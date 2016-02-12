module Web::Controllers::Items
  class Resolver
    include Web::Action

    def call(params)
      @item = ItemRepository.find_by_code(params[:code])
      redirect_to @item.content, status: 301
    end
  end
end
