class AddPaidToBorrows < ActiveRecord::Migration
  def change
    add_column :borrows, :paid?, :boolean 
  end
end
