class AddIndicesToGeographies < ActiveRecord::Migration
  def change
  	add_index :geographies, :zipcode
  	add_index :geographies, :city
  	add_index :geographies, :county
  end
end
