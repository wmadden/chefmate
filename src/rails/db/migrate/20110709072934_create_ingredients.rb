class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.integer :dish_id
      t.integer :component_id
      t.string :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients
  end
end
