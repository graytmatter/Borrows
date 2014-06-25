class ChangeTypeOfZipcode < ActiveRecord::Migration
  def change
  	change_column :signups, :zipcode, :string
  end
end
