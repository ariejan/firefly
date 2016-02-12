class Item
  include Hanami::Entity
  attributes :code, :type, :content, :created_at, :updated_at
end
