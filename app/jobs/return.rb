class Return
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 

			# Auto set status to complete and connect borrowers/lenders for return
			Borrow.where(status1: 3).select { |b| b.request.returndate.to_date == Date.today }.each do |b| 
				RequestMailer.return_reminder(b).deliver
			end

		end
	end
end