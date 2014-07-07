class ChangeDescriptionInInventories < ActiveRecord::Migration
  def change
  	change_column :inventories, :description, :text
  end
end
