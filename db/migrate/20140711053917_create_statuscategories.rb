class CreateStatuscategories < ActiveRecord::Migration
  def change
    create_table :statuscategories do |t|
      t.string :name

      t.timestamps
    end
  end
end
