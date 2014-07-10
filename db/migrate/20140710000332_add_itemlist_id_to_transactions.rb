class AddItemlistIdToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :itemlist_id, :integer
  end
end
