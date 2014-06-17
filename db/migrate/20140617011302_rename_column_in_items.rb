class RenameColumnInItems < ActiveRecord::Migration
  def change
  	rename_column :items, :name, :item_name
  end
end
