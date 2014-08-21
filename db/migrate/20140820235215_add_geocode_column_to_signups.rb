class AddGeocodeColumnToSignups < ActiveRecord::Migration
  def change
  	add_column :signups, :geocode, :string
  end
end
