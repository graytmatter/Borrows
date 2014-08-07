class AddDateToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :date, :date
  end
end
