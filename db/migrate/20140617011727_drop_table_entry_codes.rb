class DropTableEntryCodes < ActiveRecord::Migration
  def change
  	drop_table :entry_codes
  end
end
