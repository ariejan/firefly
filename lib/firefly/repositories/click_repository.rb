class ClickRepository
  include Hanami::Repository

  def self.clicks_for(item)
    query  do
      where(item_id: item.id)
    end.count
  end

  def self.register_for(item, count = 1)
    transaction do
      count.times do
        create(Click.new(item_id: item.id))
      end
    end
  end
end
