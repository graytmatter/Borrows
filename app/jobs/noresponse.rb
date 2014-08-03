class Noresponse
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	# recurs { daily.hour_of_day(23)}

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 

			# Auto set status to N/A if borrows are still outstanding on their pickup date
			Borrow.where(status1: 1).select { |b| b.request.pickupdate.to_date == Date.today}.each do |b|
				b.decline_process_test(b, 9)
			end

		end
	end
end