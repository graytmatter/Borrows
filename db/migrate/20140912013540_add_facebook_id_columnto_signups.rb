class AddFacebookIdColumntoSignups < ActiveRecord::Migration
  def change
  	add_column :signups, :facebook_id, :integer
  end
end
