class FixUserid < ActiveRecord::Migration
  def change
    rename_column :agreements, :user_id, :signup_id
  end
end
