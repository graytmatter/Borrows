require 'spec_helper'

describe "how inventory management except for accept/decline, i.e., descriptions, removal, and availability control" do

	before do 
		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(name: "2-Person tent", inventory_list: true)
		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")

		@signup = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup2 = Signup.create(email:"anavarada@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
	end
		
	it "should have 2 signups to start" do
		Signup.count.should == 2
	end

	describe "A) page should show inventory" do

		before do
			visit '/'
			fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
			click_button 'signup1'
			click_button 'lend'
			fill_in 'inventory_1', :with => 1
			click_button 'submit_lend'
		end

		it "should have inventory text" do
			Inventory.count.should == 1
			page.assert_selector("#name_1")
		end

		it "should not have update description button" do
			page.assert_no_selector("#update_description_1")
		end

		it "should have add description form" do
			page.assert_selector("#add_description_1")
		end

		describe "B) add description" do

			before do
				fill_in 'inventory_description_1', :with => "test"
				click_button 'add_description_1'
			end

			it "should have description text" do
				page.assert_selector("#description_1")
			end

			it "should have update description button" do
				page.assert_selector("#update_description_1")
			end

			it "should not have add description form" do
					page.assert_no_selector("#add_description_1")
				end

			describe "C) update description" do

				before do
					click_link 'update_description_1'
				end

				it "should have no description text" do
					page.assert_no_selector("#description_1")
				end

				it "should not have update description button" do
					page.assert_no_selector("#update_description_1")
				end

				it "should have add description form" do
					page.assert_selector("#add_description_1")
				end
			end
		end

		describe "D) Remove button should work" do

			before do
				click_link "remove_1"
			end

			it "should not have any inventory showing" do
				page.assert_no_selector("#name_1")
			end
		end

		describe "E) Turn off availability" do

			before do
				click_link "toggle_1"

			end

			it "should have inventory showing with N/A warning" do
				page.assert_selector("#name_1")
				page.assert_selector("#not_available_1")
			end

			describe "F) Turn availability back on" do

				before do
					click_link "toggle_1"
				end

				it "should have inventory showing without N/A warning" do
					page.assert_selector("#name_1")
					page.assert_no_selector("#not_available_1")
				end
			end
		end

		describe "G) Remove and toggle options should not be available if there are outstanding requests" do

			before do 

				@todays_date = Date.today
				@futures_date = Date.today+10
				# visit '/'
				# fill_in 'signup_email1', :with => "anavarada@gmail.com"
				# click_button 'signup1'
				# click_button 'borrow'
				# save_and_open_page
				# fill_in 'borrow__1', :with => 1
				# select @todays_date.year, :from => 'request_pickupdate_1i'
				# select Date::MONTHNAMES[@todays_date.month], :from => 'request_pickupdate_2i'
				# select @todays_date.day, :from => 'request_pickupdate_3i'
				# select @futures_date.year, :from => 'request_returndate_1i'
				# select Date::MONTHNAMES[@futures_date.month], :from => 'request_returndate_2i'
				# select @futures_date.day, :from => 'request_returndate_3i'
				# click_button 'submit_request'

				@request = @signup2.requests.create(pickupdate: @todays_date, returndate: @futures_date)
				@request.borrows.create(itemlist_id: 1, inventory_id: 1, multiple: 1, status1: 1)
				visit '/'
				fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
				click_button 'signup1'
				click_button 'lend'
			end

			it "should not have toggle or remove option" do
				page.assert_no_selector('#remove_1')
				page.assert_no_selector('#toggle_1')
			end

			describe "H) Remove/ toggle options back if request declined" do

				before do
					click_link 'decline 1'
				end

				it "should have toggle and remove option" do
					page.assert_selector('#remove_1')
					page.assert_selector('#toggle_1')
				end

			end

			describe "I) Remove/ toggle options still not present if request accepted" do

				before do
					click_link 'accept 1'
				end

				it "should not have toggle and remove option" do
					page.assert_no_selector('#remove_1')
					page.assert_no_selector('#toggle_1')
				end

				describe "J) But once the return date passes, the remove/ toggle options come back" do

					before do
						@future = @futures_date + 11
						Date.stub(:today).and_return(@future)
						#date stub doesn't work, tested putting Date.today in the view file, and indeed, it's never a future date 
					end

					it "should have toggle and remove option" do
						page.assert_selector('#remove_1')
						page.assert_selector('#toggle_1')
					end
				end
			end
		end
	end
end