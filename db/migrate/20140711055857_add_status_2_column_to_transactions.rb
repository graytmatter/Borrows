class AddStatus2ColumnToTransactions < ActiveRecord::Migration
  def change
  	rename_column :transactions, :status, :status1
  	add_column :transactions, :status2, :integer
  end
end
