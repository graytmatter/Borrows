class AddDatePaymentToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :rentdate, :string
    add_column :requests, :paydeliver, :boolean
  end
end
