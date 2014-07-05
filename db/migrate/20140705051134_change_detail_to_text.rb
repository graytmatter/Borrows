class ChangeDetailToText < ActiveRecord::Migration
  def change
  	change_column :requests, :detail, :text
  end
end
