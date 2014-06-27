class AddTermsOfServiceColumns < ActiveRecord::Migration
  def change
  	add_column :signups, :tos, :boolean
  end
end
