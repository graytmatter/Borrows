class Recurring
	include SuckerPunch::Job
	include FistOfFury::Recurrent

	recurs { daily }

	def perform
		ActiveRecord::Base.connection_pool.with_connection do 

			# # Auto set status to in progress from connected
			# Borrow.where(status1: 2).select { |b| b.request.pickupdate == Date.today }.each { |b| b.update_attributes(status1 == 3 ) }

			# # Auto set status to complete and connect borrowers/lenders for return
			# Borrow.where(status1: 3).select { |b| b.request.returndate == Date.today }.each do |b| 
			# 	b.update_attributes(status1 == 4 ) 
			# 	RequestMailer.return_reminder(b).deliver
			# end

			# # Auto set status to N/A if borrows are still outstanding on their pickup date
			# Borrow.where(status1: 1).select { |b| b.request.pickupdate == Date.today}.each do |b|
			# 	b.update_attributes(status1 == 20)
			# 	RequestMailer.not_found(b, b.itemlist_id).deliver
			# end

			# Auto email lenders every other day if they have outstanding requests
			lender_array = Array.new
			Inventory.where(id: (Borrow.where(status1:1).all.pluck("inventory_id"))).each { |i| lender_array << i.signup.id }
			lender_array.uniq.each { |l|InventoryMailer.outstanding_request(l).deliver }

		end
	end
end