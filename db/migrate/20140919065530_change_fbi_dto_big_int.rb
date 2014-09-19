class ChangeFbiDtoBigInt < ActiveRecord::Migration
  def change
  	change_column :invitees, :referer, :bigint
  end
end
