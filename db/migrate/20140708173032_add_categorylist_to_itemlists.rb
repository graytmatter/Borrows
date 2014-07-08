class AddCategorylistToItemlists < ActiveRecord::Migration
  def change
  	add_column :itemlists, :categorylist_id, :integer
  end
end
