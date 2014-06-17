class AddIndexToInventories < ActiveRecord::Migration
  def change
  	add_index :inventories, :item_name 
  end
end
