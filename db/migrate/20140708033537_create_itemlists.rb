class CreateItemlists < ActiveRecord::Migration
  def change
    create_table :itemlists do |t|
      t.string :name
      t.string :category
      t.boolean :request_list
      t.boolean :inventory_list

      t.timestamps
    end
  end
end
