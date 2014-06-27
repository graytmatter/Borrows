class RemoveDeliveryColumnsFromRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :rentdate
  	remove_column :requests, :paydeliver
  	remove_column :requests, :addysdeliver
  	remove_column :requests, :timedeliver
  	remove_column :requests, :instrucdeliver
  end
end
