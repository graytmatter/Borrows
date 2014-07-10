class AddIndicesToCategorylistsItemlistsStatuses < ActiveRecord::Migration
  def change
  	add_index :itemlists, :name, unique: true
  	add_index :categorylists, :name, unique: true
  	add_index :statuses, :status_meaning, unique: true
  end
end
