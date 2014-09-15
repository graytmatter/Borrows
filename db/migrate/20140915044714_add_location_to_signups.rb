class AddLocationToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :fb_location, :string
  end
end
