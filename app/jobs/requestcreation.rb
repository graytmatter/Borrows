class Requestcreation
	include SuckerPunch::Job
	include Creating
	# include Celluloid::Logger

	# Celluloid.logger = Rails.logger

	def perform(requestrecord_id, borrowparams)
		# warn(Request.all)
		ActiveRecord::Base.connection_pool.with_connection do 
			times_to_create(requestrecord_id, borrowparams)
		end
	end
end