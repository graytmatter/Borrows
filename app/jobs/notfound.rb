class Notfound
	include SuckerPunch::Job

	def perform(not_available_borrow, itemlist_id)
		ActiveRecord::Base.connection_pool.with_connection do 
			RequestMailer.not_found(not_available_borrow, itemlist_id).deliver
		end
	end
end