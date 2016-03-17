module Admin::Controllers::Dashboard
  class Index
    include Admin::Action

    expose :items

    def call(params)
      @items = ItemRepository.recent(10).all
    end
  end
end
