class CreateCategorylists < ActiveRecord::Migration
  def change
    create_table :categorylists do |t|
      t.string :name

      t.timestamps
    end
  end
end
