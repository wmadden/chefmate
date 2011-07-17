class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :dishes do |t|
      t.integer :menu_id
      t.integer :recipe_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dishes
  end
end
