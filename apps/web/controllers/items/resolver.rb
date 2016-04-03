module Web::Controllers::Items
  class Resolver
    include Web::Action

    def call(params)
      @item = ItemRepository.find_by_code(params[:code])
      result = ClickRepository.register_for(@item)
      redirect_to @item.content, status: 301
    end
  end
end
