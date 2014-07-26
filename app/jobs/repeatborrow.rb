class Repeatborrow
	include SuckerPunch::Job

	def perform(repeat_borrow, itemlist_id)
		ActiveRecord::Base.connection_pool.with_connection do 
			RequestMailer.repeat_borrow(repeat_borrow, itemlist_id).deliver
		end
	end
end