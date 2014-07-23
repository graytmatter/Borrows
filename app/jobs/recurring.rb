class Recurring
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	recurs { daily }

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 
			InventoryMailer.test.deliver
		end
	end
end