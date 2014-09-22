class Cleansignup
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	def perform(accepted)
		ActiveRecord::Base.connection_pool.with_connection do 
			Signup.where("state is not null").select { |s| s.email == nil && s.facebook_id == nil && s.name == nil }.destroy_all
			puts "signups cleaned!"
		end
	end
end