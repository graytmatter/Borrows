require 'spec_helper'

describe "borrower dashboard" do

	before do 
		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(name: "2-Person tent", request_list: true, inventory_list: true)

		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")
		
		@newstatuscategory = Statuscategory.create(name: "1 Did use PB")
		@newstatuscategory.statuses.create(name: "Checking")
		@newstatuscategory.statuses.create(name: "Connected")
		@newstatuscategory.statuses.create(name: "In progress")
		@newstatuscategory.statuses.create(name: "Complete")

		@newstatuscategory2 = Statuscategory.create(name: "1 Did not use PB")
		@newstatuscategory2.statuses.create(id: 10, name: "Forgot")
		@newstatuscategory2.statuses.create(id: 14, name: "Item not suitable")
		@newstatuscategory2.statuses.create(id: 20, name: "Not available")

		@newstatuscategory3 = Statuscategory.create(id: 4, name: "2 Did not use PB")
		@newstatuscategory3.statuses.create(name: "Borrow from neighbor")


		@signup_dd = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup_dd.inventories.create(itemlist_id: 1, available: true)
		@borrower1 = Signup.create(email:"anavarada@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
				
		@todays_date = Date.today
		@futures_date = Date.today+5
	end

	describe "first time someone logs in, should go to new request page" do

		before do
			visit '/'
			fill_in 'signup_email1', :with => "anavarada@gmail.com"
			click_button 'signup1'
			click_button 'borrow'
		end

		it "should lead to the new request page" do
			page.assert_selector("#new_request")
		end

		describe "subsequent logins, when there are borrows in checking" do

			before do
				@request1 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
				@request1.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
				visit '/'
				fill_in 'signup_email1', :with => "anavarada@gmail.com"
				click_button 'signup1'
				click_button 'borrow'
			end 

			it "should lead to management page" do
				page.assert_selector("#new-borrow")
			end

			it "should match status" do
				page.assert_selector("#borrowed item", count: 1)
				page.assert_selector("#checking")
			end

			it "should have cancel option" do
				page.assert_selector("#cancel_1")
			end

		end

		describe "subsequent logins, when there are borrows connected" do

			before do
				@request1 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
				@request1.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
				visit '/'
				fill_in 'signup_email1', :with => "anavarada@gmail.com"
				click_button 'signup1'
				click_button 'borrow'
				# save_and_open_page
			end 

			it "should lead to management page" do
				page.assert_selector("#new-borrow")
			end

			it "should match status" do
				page.assert_selector("#borrowed item", count: 1)
				page.assert_selector("#connected")
			end

			it "should have cancel option" do
				page.assert_selector("#cancel_1")
			end

		end

		describe "subsequent logins, when there are borrows in progress" do

			before do
				@request1 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
				@request1.borrows.create(multiple: 1, status1: 3, itemlist_id: 1, inventory_id: 1)
				visit '/'
				fill_in 'signup_email1', :with => "anavarada@gmail.com"
				click_button 'signup1'
				click_button 'borrow'
			end 

			it "should lead to management page" do
				page.assert_selector("#new-borrow")
			end

			it "should match status" do
				page.assert_selector("#borrowed item", count: 1)
				page.assert_selector("#in progress")
			end

			it "should not have cancel option" do
				page.assert_no_selector("#cancel_1")
			end

		end

		describe "subsequent logins, when there are borrows not available but current" do

			before do
				@request1 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
				@request1.borrows.create(multiple: 1, status1: 20, itemlist_id: 1, inventory_id: 1)
				visit '/'
				fill_in 'signup_email1', :with => "anavarada@gmail.com"
				click_button 'signup1'
				click_button 'borrow'
			end 

			it "should lead to management page" do
				page.assert_selector("#new-borrow")
			end

			it "should match status" do
				page.assert_selector("#borrowed item", count: 1)
				page.assert_selector("#not available")
			end

			it "should not have cancel option" do
				page.assert_no_selector("#cancel_1")
			end

		end

		describe "subsequent logins, when there are borrows borrower cancel but current" do

			before do
				@request1 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
				@request1.borrows.create(multiple: 1, status1: 10, itemlist_id: 1, inventory_id: 1)
				visit '/'
				fill_in 'signup_email1', :with => "anavarada@gmail.com"
				click_button 'signup1'
				click_button 'borrow'
			end 

			it "should lead to management page" do
				page.assert_selector("#new-borrow")
			end

			it "should match status" do
				page.assert_selector("borrowed item", count: 1)
				page.assert_selector("#borrower cancel")
			end

			it "should not have cancel option" do
				page.assert_no_selector("#cancel_1")
			end

		end

		describe "subsequent logins, when there are borrows not available but old, with no other borrows" do

			before do
				@request1 = @borrower1.requests.new(pickupdate: @todays_date-5, returndate: @todays_date-3)
				@request1.save(validate: false)
				@request1.borrows.create(multiple: 1, status1: 20, itemlist_id: 1, inventory_id: 1)
				visit '/'
				fill_in 'signup_email1', :with => "anavarada@gmail.com"
				click_button 'signup1'
				click_button 'borrow'
			end 

			it "should lead to regular borrow page" do
				page.assert_selector("#new_request")
			end

			describe "with other outstanding borrows" do
				
				before do
					@request2 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
					@request2.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
					visit '/'
					fill_in 'signup_email1', :with => "anavarada@gmail.com"
					click_button 'signup1'
					click_button 'borrow'
				end

				it "should lead to management page" do
					page.assert_selector("#new-borrow")
				end

				it "should not show older not available" do
					page.assert_no_selector("#not available")
					page.assert_selector("#borrowed item", count: 1)
				end

				it "should have only one cancel option for latest" do
					page.assert_selector("#cancel_2", count: 1)
				end
				
			end 

		end

		describe "subsequent logins, when there are borrows borrower cancel but old, with no other borrows" do

			before do
				@request1 = @borrower1.requests.new(pickupdate: @todays_date-5, returndate: @todays_date-3)
				@request1.save(validate: false)
				@request1.borrows.create(multiple: 1, status1: 14, itemlist_id: 1, inventory_id: 1)
				visit '/'
				fill_in 'signup_email1', :with => "anavarada@gmail.com"
				click_button 'signup1'
				click_button 'borrow'
			end 

			it "should lead to regular borrow page" do
				page.assert_selector("#new_request")
			end

			describe "with other outstanding borrows" do
				
				before do
					@request2 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
					@request2.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
					visit '/'
					fill_in 'signup_email1', :with => "anavarada@gmail.com"
					click_button 'signup1'
					click_button 'borrow'
				end

				it "should lead to management page" do
					page.assert_selector("#new-borrow")
				end

				it "should not show older borrower cancel" do
					page.assert_no_selector("#borrower cancel")
					page.assert_selector("#borrowed item", count: 1)
				end

				it "should have only one cancel option for latest" do
					page.assert_selector("#cancel_2", count: 1)
				end

			end 

		end

		describe "subsequent logins, when there are borrows complete, with no other borrows" do

			before do
				@request1 = @borrower1.requests.new(pickupdate: @todays_date-5, returndate: @todays_date-3)
				@request1.save(validate: false)
				@request1.borrows.create(multiple: 1, status1: 4, itemlist_id: 1, inventory_id: 1)
				visit '/'
				fill_in 'signup_email1', :with => "anavarada@gmail.com"
				click_button 'signup1'
				click_button 'borrow'
			end 

			it "should lead to regular borrow page" do
				page.assert_selector("#new_request")
			end

			describe "with other outstanding borrows" do
				
				before do
					@request2 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
					@request2.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
					visit '/'
					fill_in 'signup_email1', :with => "anavarada@gmail.com"
					click_button 'signup1'
					click_button 'borrow'
				end

				it "should lead to management page" do
					page.assert_selector("#new-borrow")
				end

				it "should not show older borrower cancel" do
					page.assert_selector("#borrowed item", count: 1)
				end

				it "should have only one cancel option for latest" do
					page.assert_selector("#cancel_2", count: 1)
				end
			end 
		end
	end

	describe "when cancelling an item in checking" do

		before do
			@request1 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
			@request1.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
			visit '/'
			fill_in 'signup_email1', :with => "anavarada@gmail.com"
			click_button 'signup1'
			click_button 'borrow'

			select "Forgot", from: "borrow_status1"
			click_button "cancel_1"
		end 

		it "should cancel the borrow" do
			@request1.borrows.first.status1.should == 10
			page.assert_selector("#borrower cancel")
		end

		it "should not send an email" do
			ActionMailer::Base.deliveries.size == 0
		end

		it "should no longer have cancel option" do
			page.assert_no_selector("#cancel_1")
		end

	end

	describe "when cancelling an item in connected" do

		before do
			@request1 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
			@request1.borrows.create(multiple: 1, status1: 2, itemlist_id: 1, inventory_id: 1)
			visit '/'
			fill_in 'signup_email1', :with => "anavarada@gmail.com"
			click_button 'signup1'
			click_button 'borrow'

			select "Item not suitable", from: "borrow_status1"
			select "Borrow from neighbor", from: "borrow_status2"
			click_button "cancel_1"
			save_and_open_page
		end 

		it "should cancel the borrow" do
			page.assert_selector("#borrower cancel")
			@request1.borrows.first.status1.should == 14
			@request1.borrows.first.status2.should == 8
		end

		it "should send an email" do
			ActionMailer::Base.deliveries.size == 1
		end

		it "should no longer have cancel option" do
			page.assert_no_selector("#cancel_1")
		end

	end
end
