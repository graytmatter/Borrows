class Invenborrow < ActiveRecord::Base
	belongs_to :borrow 
	belongs_to :inventory
end
