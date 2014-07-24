class ChangeColumnZipcode < ActiveRecord::Migration
  def change
  	execute 'ALTER TABLE signups ALTER zipcode TYPE integer USING zipcode::int;'
  end
end
