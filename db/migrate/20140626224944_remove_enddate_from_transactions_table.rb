class RemoveEnddateFromTransactionsTable < ActiveRecord::Migration
  def change
  	remove_column :transactions, :enddate
  end
end
