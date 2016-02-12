class ItemRepository
  include Hanami::Repository

  def self.find_by_code(code)
    query do
      where(code: code).
        limit(1)
    end.first
  end
end
