class AddColumnsToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :user_id, :integer
    add_column :requests, :tos_agree, :boolean
  end
end
