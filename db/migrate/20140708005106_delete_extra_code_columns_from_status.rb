class DeleteExtraCodeColumnsFromStatus < ActiveRecord::Migration
  def change
  	remove_column :statuses, :status
  end
end
