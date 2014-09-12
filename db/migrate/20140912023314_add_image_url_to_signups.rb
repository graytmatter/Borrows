class AddImageUrlToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :image_url, :string
  end
end
