class AddIndexToSignupsTable < ActiveRecord::Migration
  def change
  	add_index :signups, :email, unique: true
  	add_column :signups, :streetone, :string
  	add_column :signups, :streettwo, :string
  	add_column :signups, :zipcode, :integer
  end
end
