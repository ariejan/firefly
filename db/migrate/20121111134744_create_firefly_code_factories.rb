class CreateFireflyCodeFactories < ActiveRecord::Migration
  def change
    create_table :firefly_code_factories do |t|
      t.integer :count, default: 0
    end
  end
end
