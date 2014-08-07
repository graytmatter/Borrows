class ChangeColumnZipcode < ActiveRecord::Migration
  def change
  	change_column :signups, :zipcode, :integer
  end
end
