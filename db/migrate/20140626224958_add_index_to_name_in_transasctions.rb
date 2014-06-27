class AddIndexToNameInTransasctions < ActiveRecord::Migration
  def change
  	add_index :transactions, :name
  end
end
