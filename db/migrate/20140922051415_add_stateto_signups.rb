class AddStatetoSignups < ActiveRecord::Migration
  def change
  	add_column :signups, :state, :string
  end
end
