class AddColumnToBorrow < ActiveRecord::Migration
  def change
    add_column :borrows, :multiple, :integer
  end
end
