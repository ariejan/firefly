module Web::Controllers::Items
  class Resolver
    include Web::Action

    # TODO: Add http cache

    def call(params)
      @item = ItemRepository.find_by_code(params[:code])
      redirect_to @item.content, status: 301
    end
  end
end
