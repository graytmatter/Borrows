class Addcolumntosignup < ActiveRecord::Migration
  def change
  	add_column :signups, :last_emailed_on, :date
  end
end
