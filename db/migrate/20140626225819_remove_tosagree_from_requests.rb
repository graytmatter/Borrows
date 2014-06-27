class RemoveTosagreeFromRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :tos_agree
  end
end
