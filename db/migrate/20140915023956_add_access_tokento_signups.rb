class AddAccessTokentoSignups < ActiveRecord::Migration
  def change
  	add_column :signups, :fb_access_token, :string
  end
end
