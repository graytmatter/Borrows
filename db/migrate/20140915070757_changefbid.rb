class Changefbid < ActiveRecord::Migration
  def change
  	change_column :signups, :facebook_id, :bigint
  end
end
