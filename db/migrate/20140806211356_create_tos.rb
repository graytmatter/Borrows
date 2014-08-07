class CreateTos < ActiveRecord::Migration
  def change
    create_table :tos do |t|
      t.date :date

      t.timestamps
    end
  end
end
