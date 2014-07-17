class NewTable < ActiveRecord::Migration
  def change
  	drop_table :borrows_inventories
  	create_table :invenborrows do |t|
      t.belongs_to :borrows
      t.belongs_to :inventories

      t.timestamps
    end
  end
end
