class DeleteInventoryIdFromTransactions < ActiveRecord::Migration
  def change
  	remove_column :transactions, :inventory_id
  end
end
