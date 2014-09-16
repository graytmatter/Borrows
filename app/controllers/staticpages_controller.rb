class StaticpagesController < ApplicationController

	before_filter :authenticate, except: [:home, :terms, :policy, :maintenace]

	def home

		if Rails.env == "production"
			callback_url = "http://www.projectborrow.com/facebook_auth"
		else
			callback_url = "http://localhost:3000/facebook_auth"
		end
		secure_state = SecureRandom.base64(16)
		oauth = Koala::Facebook::OAuth.new(ENV['Facebook_App_ID'], ENV['Facebook_Secret'], callback_url)
		
		if flash[:rerequest] == true 
			@auth_url = oauth.url_for_oauth_code(permissions: "public_profile, email, user_location, user_friends", display: "popup", auth_type: "rerequest", state: secure_state )
		else
			@auth_url = oauth.url_for_oauth_code(permissions: "public_profile, email, user_location, user_friends", display: "popup", state: secure_state )
		end

		render :layout => false
	end

	def social
		puts "TEST"
		puts params

	end

	def terms
	end

	def policy
	end

	def maintenance
	end

	def already
	end

	def metrics
		signups = Signup.all
		@total_signups = signups.count
		@signups_who_have_request = signups.select { |s| s.requests.count > 0}.count
		   @signups_who_have_1_request = signups.select { |s| s.requests.count == 1}.count
		   @signups_who_have_mult_requests = signups.select { |s| s.requests.count > 1}.count
		@signups_who_have_inventories = signups.select { |s| s.inventories.count > 0 }.count
		   @signups_who_have_accepted_requests = Inventory.where(id: Borrow.where(status1: [1..7]).pluck("inventory_id").uniq).pluck("signup_id").uniq.count

		requests = Request.all
		@total_requests = requests.count
					request_with_dates = requests.select { |r| r.created_at.present? && r.pickupdate.present? && r.returndate.present? } 
			@same_day_requests = request_with_dates.select { |r| r.created_at.to_date == r.pickupdate.to_date }.count
			@three_day_advance_requests = request_with_dates.select { |r| 3 >= (r.pickupdate.to_date - r.created_at.to_date).to_i && r.created_at.to_date != r.pickupdate.to_date }.count
			@one_week_advance_requests = request_with_dates.select { |r| 7 >= (r.pickupdate.to_date - r.created_at.to_date).to_i && (r.pickupdate.to_date - r.created_at.to_date).to_i > 3 }.count
			@beyond_1_week_advance_requests = request_with_dates.select { |r| (r.pickupdate.to_date - r.created_at.to_date).to_i > 7 }.count

				sum_of_request_notice = 0
				request_with_dates.each do |r|
					sum_of_request_notice += (r.pickupdate.to_date - r.created_at.to_date).to_i
				end
			@avg_advance_notice = sum_of_request_notice / request_with_dates.count

			@day_long_requests = request_with_dates.select { |r| r.returndate.to_date == r.pickupdate.to_date }.count
			@three_day_long_requests = request_with_dates.select { |r| 3 >= (r.returndate.to_date - r.pickupdate.to_date).to_i }.count
			@one_week_long_requests = request_with_dates.select { |r| 7 >= (r.returndate.to_date - r.pickupdate.to_date).to_i && (r.returndate.to_date - r.pickupdate.to_date).to_i > 3}.count
			@beyond_1_week_long_requests = request_with_dates.select { |r| (r.returndate.to_date - r.pickupdate.to_date).to_i > 7}.count

				sum_of_request_time = 0
				request_with_dates.each do |r|
					sum_of_request_time += (r.returndate.to_date - r.pickupdate.to_date).to_i
				end
			@avg_borrow_length = sum_of_request_time / request_with_dates.count

			@single_borrow_request = requests.select { |r| r.borrows.count == 1 }.count
			@three_borrow_request = requests.select { |r| (r.borrows.count > 1) && (r.borrows.count <= 3) }.count
			@six_borrow_request = requests.select { |r| (r.borrows.count > 3) && (r.borrows.count <= 6) }.count
			@more_ten_borrow_request = requests.select { |r| r.borrows.count >= 10 }.count
		
		borrows = Borrow.all

			@avg_borrow_per_request = borrows.count / requests.count

		did_not_use_statuses = Status.where(statuscategory_id: 2)
		@total_borrows = borrows.count

				borrows_with_status = borrows.select { |b| b.status1.present? }
			@borrows_did_use_PB = borrows_with_status.select { |b| Status.where(statuscategory_id: 1).pluck("id").include? b.status1 }.count

			@borrows_did_not_use_PB = borrows_with_status.select { |b| did_not_use_statuses.pluck("id").include? b.status1 }.count
				@borrows_true_cancel = borrows_with_status.select{ |b| [17, 18, 19, 20, 21, 22, 36, 38].include? b.status1}.count
				@borrows_false_cancel = borrows_with_status.select{ |b| [8..16].include? b.status1 }.count

					@borrows_statuses = Hash.new
					did_not_use_statuses.each do |s|
						@borrows_statuses[s.name] = borrows_with_status.select { |b| b.status1 == s.id }.count
					end
				@borrows_statuses.reject! { |k, v| v == 0 }

				itemlist_array_b = Borrow.where("itemlist_id is not null").pluck("itemlist_id")
				itemlist_array_b.map! { |i| Itemlist.find_by_id(i).name if Itemlist.find_by_id(i).present? }
				@items_count_b = Hash.new(0)
			itemlist_array_b.each do |v|
				@items_count_b[v] += 1
			end

		inventories = Inventory.all	
		@total_inventories = inventories.count

				itemlist_array_l = inventories.pluck("itemlist_id")
				itemlist_array_l.map! { |i| Itemlist.find_by_id(i).name if Itemlist.find_by_id(i).present? }
				@items_count_l = Hash.new(0)
			itemlist_array_l.each do |v|
				@items_count_l[v] += 1
			end
	end

end
