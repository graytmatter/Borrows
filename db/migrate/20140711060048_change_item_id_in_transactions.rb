class ChangeItemIdInTransactions < ActiveRecord::Migration
  def change
  	rename_column :transactions, :item_id, :inventory_id
  end
end
