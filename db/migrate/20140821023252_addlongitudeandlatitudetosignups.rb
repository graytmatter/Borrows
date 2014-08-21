class Addlongitudeandlatitudetosignups < ActiveRecord::Migration
  def change
  	add_column :signups, :longitude, :float
  	add_column :signups, :latitude, :float
  	remove_column :signups, :geocode
  end
end
