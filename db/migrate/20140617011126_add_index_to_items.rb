class AddIndexToItems < ActiveRecord::Migration
  def change
  	add_index :transactions, :startdate
  	add_index :transactions, :enddate
  end
end
