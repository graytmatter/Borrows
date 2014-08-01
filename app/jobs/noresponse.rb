class Noresponse
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	# recurs { daily.hour_of_day(23) }

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 

			# Auto set status to N/A if borrows are still outstanding on their pickup date
			Borrow.where(status1: 1).select { |b| b.request.pickupdate.to_date == Date.today}.each do |b|
				# b.update_attributes(status1 == 20)
				RequestMailer.not_found_test(b, b.itemlist_id).deliver
			end

		end
	end
end