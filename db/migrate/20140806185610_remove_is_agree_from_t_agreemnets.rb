class RemoveIsAgreeFromTAgreemnets < ActiveRecord::Migration
  def change
    remove_column :agreements, :isAgree
  end
end
