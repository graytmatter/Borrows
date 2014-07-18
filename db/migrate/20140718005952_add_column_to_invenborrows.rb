class AddColumnToInvenborrows < ActiveRecord::Migration
  def change
    add_column :invenborrows, :status, :string
  end
end
