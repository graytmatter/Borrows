class RenameTransactionsTable < ActiveRecord::Migration
  def change
  	rename_table :transactions, :borrows
  end
end
