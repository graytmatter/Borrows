class Inprogress
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	# recurs { daily.hour_of_day(23) }

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 

			# # Auto set status to in progress from connected
			Borrow.where(status1: 2).select { |b| b.request.pickupdate.to_date == Date.today }.each do |b| 
				b.update_attributes(status1: 3)
			end
		end
	end
end