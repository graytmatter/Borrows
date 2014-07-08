class DeleteColumnsFromStatus < ActiveRecord::Migration
  def change
  	remove_column :statuses, :inventory_use
  	remove_column :statuses, :request_use
  end
end
