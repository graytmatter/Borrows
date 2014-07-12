class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :inventory_id
      t.integer :transaction_id
      t.boolean :booked

      t.timestamps
    end
  end
end
