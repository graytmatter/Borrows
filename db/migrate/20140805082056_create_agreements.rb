class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.integer :user_id
      t.date :date
      t.boolean :isAgree

      t.timestamps
    end
  end
end
