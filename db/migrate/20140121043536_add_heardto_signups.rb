class AddHeardtoSignups < ActiveRecord::Migration
  def change
  	add_column :signups, :heard, :string
  end
end
