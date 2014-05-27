class ChangeRequestDatetoDatetime < ActiveRecord::Migration
  def change
  	change_column :requests, :startdate, :datetime
  	change_column :requests, :enddate, :datetime
  end
end
