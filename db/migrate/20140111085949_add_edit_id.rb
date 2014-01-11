class AddEditId < ActiveRecord::Migration
  def change
  add_column :requests, :edit_id, :string
  end
end
