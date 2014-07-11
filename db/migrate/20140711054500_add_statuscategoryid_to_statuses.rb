class AddStatuscategoryidToStatuses < ActiveRecord::Migration
  def change
  	add_column :statuses, :statuscategory_id, :integer
  end
end
