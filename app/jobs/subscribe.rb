class Subscribe
	include SuckerPunch::Job

	def perform(new_user)
		ActiveRecord::Base.connection_pool.with_connection do 
			SignupMailer.notification_email(new_user).deliver
		end
	end
end