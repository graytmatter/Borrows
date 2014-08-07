class AddAvailabilityColumnToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :available, :boolean
  end
end
