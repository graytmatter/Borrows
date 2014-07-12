class ChangeTransactionIdToString < ActiveRecord::Migration
  def change
  	change_column :inventories, :transaction_id, :text
  end
end
