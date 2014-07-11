class ChangeStatusMeaningToName < ActiveRecord::Migration
  def change
  	rename_column :statuses, :status_meaning, :name
  end
end
