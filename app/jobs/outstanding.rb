class Outstanding
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 

			# Auto email lenders every other day if they have outstanding requests
			lender_array = Array.new
			Inventory.where(id: (Borrow.where(status1:1).all.pluck("inventory_id"))).select { |i| (Date.today - i.signup.last_emailed_on) >= 2}.each { |i| lender_array << i.signup.id }
			lender_array.uniq!
			lender_array.each { |l|InventoryMailer.outstanding_request(l).deliver }

		end
	end
end