class AddSecureIdToBorrows < ActiveRecord::Migration
  def change
  	add_column :borrows, :secure_id, :string
  end
end
