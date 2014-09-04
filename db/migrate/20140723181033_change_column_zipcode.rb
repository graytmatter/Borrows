class ChangeColumnZipcode < ActiveRecord::Migration
  
  if Rails.env == "production"
	  def change
	  	execute 'ALTER TABLE signups ALTER zipcode TYPE integer USING zipcode::int;'
	  end
	end
end
