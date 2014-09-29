class Cleansignup
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 
			Signup.where("email is null").where("name is null").destroy_all
			puts "signups cleaned!"
		end
	end
end