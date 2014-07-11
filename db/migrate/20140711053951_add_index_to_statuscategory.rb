class AddIndexToStatuscategory < ActiveRecord::Migration
  def change
  	add_index :statuscategories, :name, unique: true
  end
end
