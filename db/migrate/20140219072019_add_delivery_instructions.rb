class AddDeliveryInstructions < ActiveRecord::Migration
  def change
    add_column :requests, :addysdeliver, :string
    add_column :requests, :timedeliver, :string
    add_column :requests, :instrucdeliver, :string
  end
end
