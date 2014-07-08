class RemoveCategoryFromItemlist < ActiveRecord::Migration
  def change
  	remove_column :itemlists, :category
  end
end
