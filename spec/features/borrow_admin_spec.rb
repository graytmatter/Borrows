require 'spec_helper'

describe "borrows should be listed" do

	before do 
		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(id: 1, name: "2-Person tent", request_list: true)
		@newcategory.itemlists.create(id: 2, name: "3-Person tent", request_list: true)
		@newcategory.itemlists.create(id: 3, name: "4-Person tent", request_list: true)
		@newcategory.itemlists.create(id: 4, name: "Backpack", request_list: true)
		@newcategory.itemlists.create(id: 5, name: "Hammock", request_list: true)
		@newcategory.itemlists.create(id: 6, name: "Water purifier", request_list: true)

		@newstatuscategory = Statuscategory.create(name: "1 - Did use PB")
		@newstatuscategory.statuses.create(name: "Checking")
		@newstatuscategory.statuses.create(name: "Connected")
		@newstatuscategory.statuses.create(name: "In progress")
		@newstatuscategory.statuses.create(name: "Complete")

		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")
		Geography.create(zipcode:94111, city:"Test", county:"San Francisco")
		Geography.create(zipcode:99999, city:"Out of area", county: "Out of area")
		@todays_date = Date.today+2
		@futures_date = Date.today+5

		@lender1 = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@lender1.inventories.create(id: 1, itemlist_id: 1)
		@lender1.inventories.create(id: 2, itemlist_id: 2)
		@lender1.inventories.create(id: 3, itemlist_id: 3)

		@lender2 = Signup.create(email:"anavarada@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94111, tos: true)
		@lender2.inventories.create(id: 4, itemlist_id: 3)
		@lender2.inventories.create(id: 5, itemlist_id: 5)
		@lender2.inventories.create(id: 6, itemlist_id: 6)

		@lender3 = Signup.create(email: "ngomenclature@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 99999, tos: true)
		@lender3.inventories.create(id: 7, itemlist_id: 4)

		@borrower1 = Signup.create(email:"jdong8@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@request1 = @borrower1.requests.create(pickupdate: @todays_date, returndate: @futures_date)
		@request1.borrows.create(multiple: 1, status1: 2, itemlist_id: 3, inventory_id: 3)
		@request1.borrows.create(multiple: 2, status1: 2, itemlist_id: 3, inventory_id: 4)
		@request1.borrows.create(multiple: 1, status1: 1, itemlist_id: 5, inventory_id: 5)
		@request2 = @borrower1.requests.create(pickupdate: @todays_date+5, returndate: @futures_date+7)
		@request2.borrows.create(multiple: 1, status1: 1, itemlist_id: 5, inventory_id: nil)

		@borrower2 = Signup.create(email:"dancingknives@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@request3 = @borrower2.requests.create(pickupdate: @todays_date, returndate: @futures_date)
		@request3.borrows.create(multiple: 1, status1: 2, itemlist_id: 2, inventory_id: 2)
		@request3.borrows.create(multiple: 1, status1: 3, itemlist_id: 2, inventory_id: 2)
		@request3.borrows.create(multiple: 1, status1: 4, itemlist_id: 6, inventory_id: 6)
		@request4 = @borrower2.requests.create(pickupdate: @todays_date+8, returndate: @futures_date+9)
		@request4.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
		@request4.borrows.create(multiple: 1, status1: 1, itemlist_id: 4, inventory_id: 7)

	end
		
	it "should have records to start" do
		Signup.count.should == 5
		Inventory.count.should == 7
		Request.count.should == 4
		Borrow.count.should == 9
	end

	describe "visit to borrows admin page" do 
		
		before do
			visit '/admin/borrows'
		end

		it "should have right count" do
			page.assert_selector('#row', count: Borrow.count)
		end

		describe "lender email filter" do

			before do
				select "jamesdd9302@yahoo.com", :from => "q_inventory_id_eq_any"
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.where(inventory_id: Inventory.where(signup_id: Signup.find_by_email("jamesdd9302@yahoo.com").id).pluck("id") ).count)
			end
		end

		describe "status1 filter" do

			before do
				select "Checking", :from => "q_status1_eq"
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.where(status1: 1).count)
			end
		end

		describe "item filter" do

			before do
				select "2-Person tent", :from => "q_itemlist_id_eq"
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.where(itemlist_id: 1).count)
			end
		end

		describe "borrower email filter" do

			before do
				fill_in "q_request_signup_email_cont", with: "jdong"
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.select { |b| b.request.signup.email == "jdong8@gmail.com" }.count)
			end
		end

		describe "pickupdate on filter" do

			before do
				fill_in "q_request_pickupdate_eq", with: @todays_date
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.select { |b| b.request.pickupdate.to_date == @todays_date }.count)
			end
		end

		describe "returndate on filter" do

			before do
				fill_in "q_request_returndate_eq", with: @futures_date
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.select { |b| b.request.returndate.to_date == @futures_date }.count)
			end
		end

		describe "pickupdate on or after filter" do

			before do
				fill_in "q_request_pickupdate_gteq", with: @todays_date+1
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.select { |b| b.request.pickupdate.to_date > @todays_date+1 }.count)
			end
		end

		describe "returndate on or before filter" do

			before do
				fill_in "q_request_returndate_lteq", with: @futures_date+5
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.select { |b| b.request.returndate.to_date < @futures_date+5 }.count)
			end
		end

		describe "county filter" do
			before do
				select "San Francisco", :from => "q_request_signup_zipcode_eq_any"
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: Borrow.select { |b| Geography.where(county: "San Francisco").pluck("zipcode").include? b.request.signup.zipcode }.count)
			end
		end

		describe "all filters together" do
			before do
				fill_in "q_request_returndate_lteq", with: @futures_date+5
				fill_in "q_request_signup_email_cont", with: "jdong"
				select "anavarada@gmail.com", :from => "q_inventory_id_eq_any"
				select "4-Person tent", :from => "q_itemlist_id_eq"
				click_button "search"
			end

			it "should have right count" do
				page.assert_selector('#row', count: 1)
			end
		end

		describe "make updates" do

			before do
				click_link "update 1"
				select "anavarada@gmail.com +", :from => "borrow_inventory_id"
				select "Complete", :from => "borrow_status1"
				click_button "update"
			end

			it "should update and change count" do
				Inventory.find_by_id(Borrow.find_by_id(1).inventory_id).signup.email == "anavarada@gmail.com" 
				Borrow.find_by_id(1).status1 == 4
			end
		end


	end

end