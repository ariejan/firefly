require 'hanami/interactor'

class RegisterClick
  include Hanami::Interactor
  expose :item, :click

  def initialize(item)
    @item = item
    @click = Click.new(item_id: item.id)
  end

  def call
    @click = ClickRepository.persist(@click)
  end
end
