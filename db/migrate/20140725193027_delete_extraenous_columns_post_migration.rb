class DeleteExtraenousColumnsPostMigration < ActiveRecord::Migration
  def change
  	remove_column :borrows, :name
  	remove_column :inventories, :item_name
  	remove_column :requests, :name
  	remove_column :requests, :email
  	remove_column :requests, :items
  	remove_column :requests, :heard
  end
end
