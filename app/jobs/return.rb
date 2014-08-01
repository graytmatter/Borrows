class Return
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	# recurs { daily.hour_of_day(5) }

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 

			# Auto set status to complete and connect borrowers/lenders for return
			Borrow.where(status1: 3).select { |b| b.request.returndate == Date.today }.each do |b| 
				# b.update_attributes(status1 == 4 ) 
				RequestMailer.return_reminder(b).deliver
			end

		end
	end
end