class CreateEntryCodes < ActiveRecord::Migration
  def change
    create_table :entry_codes do |t|
      t.string :code
      t.boolean :active, :default=>true

      t.timestamps
    end
    add_index :entry_codes, :code
  end
end
