class AddItemlistIdToInventories < ActiveRecord::Migration
  def change
  	add_column :inventories, :itemlist_id, :integer
  end
end
