class ClickRepository
  include Hanami::Repository

  def self.count_for(item)
    query  do
      where(item_id: item.id)
    end.count
  end
end
