class ChangeRequestColumnName < ActiveRecord::Migration
  def change
  	rename_column :requests, :item, :items
  end
end
