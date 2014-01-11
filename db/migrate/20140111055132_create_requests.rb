class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :name
      t.string :email
      t.stringgi :item
      t.string :detail

      t.timestamps
    end
  end
end
