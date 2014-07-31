require 'spec_helper'

describe "how inventory upload should work" do

	before do 
		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(name: "2-Person tent", inventory_list: true)

		@signup = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
	end
		
	it "should have 0 inventories and 1 signups to start" do
		Signup.count.should == 1
		Inventory.count.should == 0
	end

	describe "A) inventory creation" do

		before do
			visit '/'
			fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
			click_button 'signup1'
			click_button 'lend'
		end

		it "should have inventory form" do
			page.assert_selector("#new_inventory")
		end

		describe "B) submit nothing" do
			before do
				click_button 'submit_lend'
			end

			it "should not create inventory" do
				Inventory.count.should == 0
			end

			it "should rerender page with errors" do
				page.assert_selector("#new_inventory")
				page.assert_selector("#error")
			end
		end

		describe "C) submit something" do
			before do
				fill_in 'inventory_1', :with => 2
				click_button 'submit_lend'
			end

			it "should create inventory" do
				Inventory.count.should == 2
			end

			it "should render management page with opportunity to write descriptions" do
				page.assert_selector("#inventory_description_1")
				page.assert_selector("#inventory_description_2")
			end
		end
	end
end

			