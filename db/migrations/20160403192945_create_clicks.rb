Hanami::Model.migration do
  change do
    create_table :clicks do
      primary_key :id
      column :item_id,      Integer,    null: false
      column :created_at,   DateTime,   null: false
    end
  end
end
