class RenameUserIdColumn < ActiveRecord::Migration
  def change
  	rename_column :requests, :user_id, :signup_id
  	rename_column :inventories, :user_id, :signup_id
  end
end
