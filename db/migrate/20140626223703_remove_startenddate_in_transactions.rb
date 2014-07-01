class RemoveStartenddateInTransactions < ActiveRecord::Migration
  def change
  	remove_column :transactions, :startdate
  end
end
