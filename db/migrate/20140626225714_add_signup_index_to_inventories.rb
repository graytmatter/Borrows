class AddSignupIndexToInventories < ActiveRecord::Migration
  def change
  	add_index :inventories, :signup_id
  end
end
