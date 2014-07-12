class Bookings < ActiveRecord::Base
	belongs_to :inventory
	belongs_to :transaction
end
