class AddColumnToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :transaction_id, :integer
  end
end
