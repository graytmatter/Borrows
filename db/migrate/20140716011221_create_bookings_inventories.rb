class CreateBookingsInventories < ActiveRecord::Migration
  def change
    create_table :borrows_inventories do |t|
      t.belongs_to :borrows
      t.belongs_to :inventories

      t.timestamps
    end
  end
end
