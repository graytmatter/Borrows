class AddDescriptionToInvenetories < ActiveRecord::Migration
  def change
  	add_column :inventories, :description, :string
  end
end
