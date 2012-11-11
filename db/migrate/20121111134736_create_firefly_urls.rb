class CreateFireflyUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string   :url,          index: true, length: 255
      t.string   :code,         index: true, length: 64
      t.integer  :clicks,       default: 0
      t.datetime :created_at
    end
  end
end
