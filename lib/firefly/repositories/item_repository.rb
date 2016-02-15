class ItemRepository
  include Hanami::Repository

  def self.find_by_code(code)
    find Base62.decode(code)
  end

  def self.create_from_url(url)
    transaction do
      item = query.where(content: url).first
      item ||= Item.new(type: 'url', content: url)

      persist(item)
    end
  end
end
