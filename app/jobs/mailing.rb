class Mailing
	include SuckerPunch::Job

	def perform(new_user)
		new_user.save_subscrip
	end
end