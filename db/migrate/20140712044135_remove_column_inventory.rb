class RemoveColumnInventory < ActiveRecord::Migration
  def change
  	remove_column :inventories, :transaction_id
  end
end
