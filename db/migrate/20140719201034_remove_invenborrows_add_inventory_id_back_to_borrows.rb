class RemoveInvenborrowsAddInventoryIdBackToBorrows < ActiveRecord::Migration
  def change
  	drop_table :invenborrows 
  	add_column :borrows, :inventory_id, :integer
  end
end
