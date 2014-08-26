require 'spec_helper'

describe "how users search for requests" do

	before do 
		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(name: "2-Person tent", request_list: true, inventory_list: true)
		@newcategory.itemlists.create(name: "Sleeping bag", request_list: true, inventory_list: true)
		@newcategory.itemlists.create(name: "Sleeping pad", request_list: true, inventory_list: true)

		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")
		Geography.create(zipcode:94111, city:"San Francisco", county:"San Francisco")

		@signup_lender1 = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup_lender2 = Signup.create(email:"jdong8@gmail.com", streetone: "California", streettwo: "Battery", zipcode: 94111, tos: true)
		
		@signup_lender1.inventories.create(itemlist_id: 1, available: true)
		@signup_lender1.inventories.create(itemlist_id: 2, available: true)
		@signup_lender1.inventories.create(itemlist_id: 3, available: true)

		@signup_lender2.inventories.create(itemlist_id: 2, available: true)
		@signup_lender2.inventories.create(itemlist_id: 3, available: true)

		@todays_date = Date.today
		@futures_date = Date.today+5
	end

	describe "A) test page should be pre-populated with markers (not itself)" do

		before do
			@signup_borrower = Signup.create(email: "anavarada@gmail.com", streetone: "Post", streettwo: "Leavenworth", zipcode: 94109, tos: true)
			visit '/test'
			# click ''
			# save_and_open_page
		end

		it "should have a map" do
			page.assert_selector("#map-canvas")
		end

		it "should have as many markers as lenders" do
			page.should have_selector('area[title^="lender_marker"]', visible: false, count: 2)
			# page shoudl not have anavarada
		end

		it "should have empty cart" do
			within("div#cart") do 
				page.should have_css('li', :count => 0) 
			end 
		end
	end

	describe "B) test page should be pre-populated with markers specific to geography" do

		before do
			Geography.create(zipcode:94609, city:"Oakland", county:"Alameda")
		
			@signup_borrower = Signup.create(email: "anavarada@gmail.com", streetone: "Alcatraz", streettwo: "Hillegass", zipcode: 94609, tos: true)
			@signup_lender3 = Signup.create(email:"ngomenclature@gmail.com", streetone: "Alcatraz", streettwo: "Telegraph", zipcode: 94609, tos: true)
			@signup_lender3.inventories.create(itemlist_id: 1, available: true)
			visit '/test'
			# click ''
			# save_and_open_page
		end

		it "should have a map" do
			page.assert_selector("#map-canvas")
		end

		it "should have as many markers as lenders" do
			# page.should have_selector(div[title='lender_marker ngomenclature@yahoo.com'])
			# page.should_not have_selectr (dd/ jdong)
		end
	end

end