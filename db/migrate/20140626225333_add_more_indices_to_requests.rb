class AddMoreIndicesToRequests < ActiveRecord::Migration
  def change
  	add_index :requests, :signup_id

  end
end
