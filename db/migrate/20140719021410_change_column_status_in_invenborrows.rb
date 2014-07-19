class ChangeColumnStatusInInvenborrows < ActiveRecord::Migration
  def change
  	change_column :invenborrows, :status, :boolean
  	rename_column :invenborrows, :status, :accepted
  end
end
