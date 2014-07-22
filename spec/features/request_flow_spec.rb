require 'spec_helper'

describe "how requests should flow" do

	def login(email, choice, quantity = '', pickup_month='', pickup_date='', return_month='', return_date='')
		visit '/'
		fill_in 'signup_email1', :with => email
		click_button 'signup1'
		click_button choice

		if choice == "borrow"
			fill_in 'borrow__1', :with => quantity
			select '2015', :from => 'request_pickupdate_1i'
			select pickup_month, :from => 'request_pickupdate_2i'
			select pickup_date, :from => 'request_pickupdate_3i'
			select '2015', :from => 'request_returndate_1i'
			select return_month, :from => 'request_returndate_2i'
			select return_date, :from => 'request_returndate_3i'
			click_button 'submit_request'
		end
	end

	def record_test(request_total, borrow_total, borrow_checking_total, borrow_connected_total, borrow_lender_declined_total, borrow_other_did_not_use_total, borrow_not_available_total)
		Request.count.should == request_total
		Borrow.count.should == borrow_total
		Borrow.where(status1: 1).count.should == borrow_checking_total
		Borrow.where(status1: 2).count.should == borrow_connected_total
		Borrow.where(status1: 21).count.should == borrow_lender_declined_total
		Borrow.where(status1: [8,9,10,11,12,13,14,15,16,17,18,19,22]).count.should == borrow_other_did_not_use_total
		Borrow.where(status1: 20).count.should == borrow_not_available_total
	end

	def email_test(total_count, subject_line='')
		ActionMailer::Base.deliveries.size == total_count
		# expect(mail.subject).to eql(subject_line) unless subject_line == ''
	end

	def manage_test(lender_email, manage_count, connected_count)
		login(lender_email, "lend")

		page.assert_selector("#manage", :count => manage_count)
		page.assert_selector("#connected", :count => connected_count)
	end

	before do 
		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(name: "2-Person tent", request_list: true)
		# status_codes = {
		#   "1 Did use PB" => [
		#     "Checking", #1
		#     "Connected", #2
		#     "In progress", #3
		#     "Complete" #4
		#   ],
		#   "1 Did not use PB" => [
		#     "FC - Generic", #5
		#     "TC - Not available", #6
		#     "TC - Lender declined" #7
		#   ]
		# }
		# status_codes.each do |c, s|
		#   Statuscategory.create(name: c)
		#   s.each do |s|
		#     Statuscategory.find_by_name(c).statuses.create(name: s)
		#   end
		# end

		@signup_dd = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_jdong = Signup.create(email:"jdong8@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_ana = Signup.create(email: "anavarada@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_ngo = Signup.create(email: "ngomenclature@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_dance = Signup.create(email: "dancingknives@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_borrows = Signup.create(email: "borrowsapp@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)

		@signup_dd.inventories.create(itemlist_id: 1)
		@signup_jdong.inventories.create(itemlist_id: 1)
	end
		
	it "should have 2 inventories and 2 signups to start" do
		Signup.count.should == 6
		Inventory.count.should == 2
	end

	describe "A) request creation" do

		before do
			# ApplicationController.stub(session[:signup_email]).and_return("anavarada@gmail.com")
			# visit '/requests/new'
			# save_and_open_page
			
			# visit '/'
			# page.driver.post new_signup_path, :signup_email => "anavarada@gmail.com"
			# visit '/requests/new'

			# visit '/requests/new'
			# RequestController.session.stub(:[]).with(:signup_email).and_return("anavarada@gmail.com")

			# ActionController::Session::AbstractStore::SessionHash.any_instance.stubs(:signup_email).returns("anavarada@gmail.com")
			# visit '/requests/new'

			login("anavarada@gmail.com", "borrow", 1, "January", "1", "January", "5")
		end

		it "should affect records" do
			# 1- request_total, 
			# 2- borrow_total, 
			# 3- borrow_checking_total, 
			# 4- borrow_connected_total, 
			# 5- borrow_lender_declined_total, 
			# 6- borrow_other_did_not_use_total
			# 7- borrow_not_available_total
			record_test(1, 2, 2, 0, 0, 0, 0)
		end

		it "should affect emails" do
			#(count, subject: blank)
			email_test(0)
		end

		it "should affect management options for lenders" do 
			#(lender_email, manage_count, connected_count)
			manage_test("jamesdd9302@yahoo.com", 1, 0)
			manage_test("jdong8@gmail.com", 1, 0)
		end

		describe "B) jamesdd9302 declines" do

			before do
				login("jamesdd9302@yahoo.com", "lend")
				click_link 'decline'
			end

			it "should affect records" do
				# 1- request_total, 
				# 2- borrow_total, 
				# 3- borrow_checking_total, 
				# 4- borrow_connected_total, 
				# 5- borrow_lender_declined_total, 
				# 6- borrow_other_did_not_use_total
				# 7- borrow_not_available_total
				record_test(1, 2, 1, 0, 1, 0, 0)
			end

			it "should affect emails" do
				#(total_count, subject: blank)
				email_test(0)
			end

			it "should affect management options for lenders" do 
				#(lender_email, manage_count, connected_count)
				manage_test("jamesdd9302@yahoo.com", 0, 0)
				manage_test("jdong8@gmail.com", 1, 0)
			end

			describe "C) jdong8 declines" do

				before do
					login("jdong8@gmail.com", "lend")
					click_link 'decline'
				end

				it "should affect Requests and Borrows" do
					# 1- request_total, 
					# 2- borrow_total, 
					# 3- borrow_checking_total, 
					# 4- borrow_connected_total, 
					# 5- borrow_lender_declined_total, 
					# 6- borrow_other_did_not_use_total
					# 7- borrow_not_available_total
					record_test(1, 1, 0, 0, 1, 0, 0)
				end

				it "should affect emails" do
					#(total_count, subject: blank)
					email_test(1, "not find")
				end

				it "should affect management options for lenders" do 
					#(lender_email, manage_count, connected_count)
					manage_test("jamesdd9302@yahoo.com", 0, 0)
					manage_test("jdong8@gmail.com", 0, 0)
				end

				describe "D) admin reset to checking for jamesdd9302" do
					#don't create second record back, this is just a customary thing for the borrower to accept, i'd only do this when I know who's going to accept

					before do
						Borrow.update_all(status1: 1, inventory_id: 1)
					end

					it "should affect Requests and Borrows" do
						# 1- request_total, 
						# 2- borrow_total, 
						# 3- borrow_checking_total, 
						# 4- borrow_connected_total, 
						# 5- borrow_lender_declined_total, 
						# 6- borrow_other_did_not_use_total
						# 7- borrow_not_available_total
						record_test(1, 1, 1, 0, 0, 0, 0)
					end

					it "should affect emails" do
						#(total_count, subject: blank)
						email_test(1)
					end

					it "should affect management options for lenders" do 
						#(lender_email, manage_count, connected_count)
						manage_test("jamesdd9302@yahoo.com", 1, 0)
						manage_test("jdong8@gmail.com", 0, 0)
					end

					describe "E) start same dates same user test, new request" do

						before do
							login("anavarada@gmail.com", "borrow", 1, "January", "2", "January", "6")
						end

						it "should affect Requests and Borrows" do
							# 1- request_total, 
							# 2- borrow_total, 
							# 3- borrow_checking_total, 
							# 4- borrow_connected_total, 
							# 5- borrow_lender_declined_total, 
							# 6- borrow_other_did_not_use_total
							# 7- borrow_not_available_total
							record_test(2, 2, 1, 0, 0, 0, 1)
						end

						it "should affect emails" do
							#(total_count, subject: blank)
							email_test(2, "not found")
						end

						it "should affect management options for lenders" do 
							#(lender_email, manage_count, connected_count)
							manage_test("jamesdd9302@yahoo.com", 1, 0)
							manage_test("jdong8@gmail.com", 0, 0)
						end
					end
				end
			end
		end
	end
end