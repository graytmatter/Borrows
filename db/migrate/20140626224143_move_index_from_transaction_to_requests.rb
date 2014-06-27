class MoveIndexFromTransactionToRequests < ActiveRecord::Migration
  def change
  	rename_column :requests, :startdate, :pickupdate
  	rename_column :requests, :enddate, :returndate
  	add_index :requests, :pickupdate
  	add_index :requests, :returndate
  end
end
