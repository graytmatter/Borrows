class ChangeRequestTable < ActiveRecord::Migration
  def change
  	add_column :requests, :startdate, :datetime
  	add_column :requests, :enddate, :datetime
  end
end
