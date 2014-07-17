class AmendInvenborrows < ActiveRecord::Migration
  def change
  	drop_table :invenborrows
  	create_table :invenborrows do |t|
      t.belongs_to :borrow
      t.belongs_to :inventory

      t.timestamps
    end
  end
end
