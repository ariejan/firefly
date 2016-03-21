module Admin::Controllers::Items
  class Destroy
    include Admin::Action

    def call(params)
      @item = ItemRepository.find(params[:id])
      ItemRepository.delete(@item)

      redirect_to '/admin'
    end
  end
end
