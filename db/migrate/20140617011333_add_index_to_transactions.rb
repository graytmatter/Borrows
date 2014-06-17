class AddIndexToTransactions < ActiveRecord::Migration
  def change
  	add_index :items, :item_name
  end
end
