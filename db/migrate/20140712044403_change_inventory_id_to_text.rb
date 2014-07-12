class ChangeInventoryIdToText < ActiveRecord::Migration
  def change
  	change_column :transactions, :inventory_id, :text
  end
end
