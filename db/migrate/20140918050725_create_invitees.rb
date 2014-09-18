class CreateInvitees < ActiveRecord::Migration
  def change
    create_table :invitees do |t|
      t.string :email
      t.boolean :sent
      t.integer :referer

      t.timestamps
    end
  end
end
