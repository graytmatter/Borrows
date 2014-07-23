class Sameday
	include SuckerPunch::Job

	def perform(requestrecord)
		ActiveRecord::Base.connection_pool.with_connection do 
			RequestMailer.same_as_today(requestrecord).deliver
		end
	end
end

