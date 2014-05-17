class AddColumnToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :heard, :string
  end
end
