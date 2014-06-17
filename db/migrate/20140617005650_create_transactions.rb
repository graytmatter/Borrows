class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :request_id
      t.integer :item_id
      t.string :name
      t.datetime :startdate
      t.datetime :enddate
      t.integer :status

      t.timestamps
    end
  end
end
