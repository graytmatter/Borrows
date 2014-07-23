class Connect
	include SuckerPunch::Job

	def perform(accepted)
		ActiveRecord::Base.connection_pool.with_connection do 
			RequestMailer.connect_email(accepted).deliver
		end
	end
end