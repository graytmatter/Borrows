class AddColumnToGeographies < ActiveRecord::Migration
  def change
    add_column :geographies, :city, :string
  end
end
