module Web::Controllers::Items
  class Resolver
    include Web::Action

    cache_control :private, max_age: 90

    def call(params)
      @item = ItemRepository.find_by_code(params[:code])
      RegisterClick.new(@item).call
      redirect_to @item.content, status: 301
    end
  end
end
