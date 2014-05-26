class ChangeRequestStartdateAndEnddate < ActiveRecord::Migration
  def change
  	change_column :requests, :startdate, :date
  	change_column :requests, :enddate, :date
  end
end
