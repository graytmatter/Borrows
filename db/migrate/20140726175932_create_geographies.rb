class CreateGeographies < ActiveRecord::Migration
  def change
    create_table :geographies do |t|
      t.integer :zipcode
      t.string :county

      t.timestamps
    end
  end
end
