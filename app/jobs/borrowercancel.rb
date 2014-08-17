class Borrowercancel
	include SuckerPunch::Job

	def perform(borrow_id)
		ActiveRecord::Base.connection_pool.with_connection do 
			RequestMailer.borrower_cancel(borrow_id).deliver
		end
	end
end