class AddMoreIndicesToTransactions < ActiveRecord::Migration
  def change
  	add_index :transactions, :request_id
  	add_index :transactions, :item_id
  end
end
