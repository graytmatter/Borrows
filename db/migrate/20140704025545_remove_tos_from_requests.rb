class RemoveTosFromRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :tos
  end
end
