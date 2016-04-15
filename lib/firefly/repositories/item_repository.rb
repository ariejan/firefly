class ItemRepository
  include Hanami::Repository

  def self.find_by_code(code)
    find Base62.decode(code)
  end

  def self.recent(limit = 10)
    query do
      desc(:created_at).limit(limit)
    end
  end

  def self.count
    query.count
  end

  def self.find_by_content(item)
    query do
      where(content: item.content, type: item.type)
    end.first
  end
end
