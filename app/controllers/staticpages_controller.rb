class StaticpagesController < ApplicationController

	before_filter :authenticate, except: [:terms, :policy, :maintenace]

	def terms
	end

	def policy
	end

	def maintenance
	end

	def metrics
		@total_signups = Signup.count
		@signups_who_have_request = Signup.select { |s| s.requests.count > 0}.count
		   @signups_who_have_1_request = Signup.select { |s| s.requests.count == 1}.count
		   @signups_who_have_mult_requests = Signup.select { |s| s.requests.count > 1}.count
		@signups_who_have_inventories = Signup.select { |s| s.inventories.count > 0 }.count
		   @signups_who_have_accepted_requests = Inventory.where(id: Borrow.where(status1: [1..7]).pluck("inventory_id").uniq).pluck("signup_id").uniq.count


		@total_requests = Request.count
			@avg_borrow_per_request = Borrow.count / Request.count

				request_with_dates = Request.where("created_at is not null").where("pickupdate is not null").where("returndate is not null") 
			@same_day_requests = request_with_dates.select { |r| r.created_at.to_date == r.pickupdate.to_date }.count
			@three_day_advance_requests = request_with_dates.select { |r| 3 >= (r.pickupdate.to_date - r.created_at.to_date).to_i && r.created_at.to_date != r.pickupdate.to_date }.count
			@one_week_advance_requests = request_with_dates.select { |r| 7 >= (r.pickupdate.to_date - r.created_at.to_date).to_i && (r.pickupdate.to_date - r.created_at.to_date).to_i > 3 }.count
			@beyond_1_week_advance_requests = request_with_dates.select { |r| (r.pickupdate.to_date - r.created_at.to_date).to_i > 7 }.count

				sum_of_request_notice = 0
				request_with_dates.all.each do |r|
					sum_of_request_notice += (r.pickupdate.to_date - r.created_at.to_date).to_i
				end
			@avg_advance_notice = sum_of_request_notice / request_with_dates.count

			@day_long_requests = request_with_dates.select { |r| r.returndate.to_date == r.pickupdate.to_date }.count
			@three_day_long_requests = request_with_dates.select { |r| 3 >= (r.returndate.to_date - r.pickupdate.to_date).to_i }.count
			@one_week_long_requests = request_with_dates.select { |r| 7 >= (r.returndate.to_date - r.pickupdate.to_date).to_i && (r.returndate.to_date - r.pickupdate.to_date).to_i > 3}.count
			@beyond_1_week_long_requests = request_with_dates.select { |r| (r.returndate.to_date - r.pickupdate.to_date).to_i > 7}.count

				sum_of_request_time = 0
				request_with_dates.all.each do |r|
					sum_of_request_time += (r.returndate.to_date - r.pickupdate.to_date).to_i
				end
			@avg_borrow_length = sum_of_request_time / request_with_dates.count


		@total_borrows = Borrow.count

				borrows_with_status = Borrow.where("status1 is not null")
			@borrows_did_use_PB = borrows_with_status.where(status1: Status.where(statuscategory_id: 1).pluck("id")).count

			@borrows_did_not_use_PB = borrows_with_status.where(status1: Status.where(statuscategory_id: 2).pluck("id")).count
				@borrows_true_cancel = borrows_with_status.where(status1: [17..22, 36, 38]).count
				@borrows_false_cancel = borrows_with_status.where(status1: [8..16]).count

					@borrows_statuses = Hash.new
					Status.where(statuscategory_id: [2]).each do |s|
						@borrows_statuses[s.name] = borrows_with_status.where(status1: s.id).count
					end
				@borrows_statuses.reject! { |k, v| v == 0 }

				borrows_with_itemlist_id = Borrow.where("itemlist_id is not null")
				itemlist_array_b = borrows_with_itemlist_id.pluck("itemlist_id")
				itemlist_array_b.map! { |i| Itemlist.find_by_id(i).name }
				@items_count_b = Hash.new(0)
			itemlist_array_b.each do |v|
				@items_count_b[v] += 1
			end


		@total_inventories = Inventory.count
		
				itemlist_array_l = Inventory.pluck("itemlist_id")
				itemlist_array_l.map! { |i| Itemlist.find_by_id(i).name }
				@items_count_l = Hash.new(0)
			itemlist_array_l.each do |v|
				@items_count_l[v] += 1
			end
	end

end