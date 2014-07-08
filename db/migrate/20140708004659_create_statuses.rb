class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :status
      t.string :status_meaning
      t.boolean :inventory_use
      t.boolean :request_use

      t.timestamps
    end
  end
end
