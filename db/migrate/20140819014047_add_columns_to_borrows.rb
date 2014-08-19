class AddColumnsToBorrows < ActiveRecord::Migration
  def change
    add_column :borrows, :signup_id,     :integer
    add_column :borrows, :refunded?,     :boolean
    add_column :borrows, :amount,        :integer
    add_column :borrows, :paid_date,     :date
    add_column :borrows, :refunded_date, :date
  end
end
