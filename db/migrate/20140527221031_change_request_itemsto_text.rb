class ChangeRequestItemstoText < ActiveRecord::Migration
  def change
  	change_column :requests, :items, :text
  end
end
