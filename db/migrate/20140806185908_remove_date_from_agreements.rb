class RemoveDateFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :date
  end
end
