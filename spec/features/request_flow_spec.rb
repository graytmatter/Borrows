require 'spec_helper'

describe "how requests should flow" do
	
	# it "should prefill request page based on email entered in home page" do
	# 	Signup.create(email:"jdong8@gmail.com")
	# 	visit new_request_path
	# 	save_and_open_page
	# 	expect(page).to have_content "jdong8@gmail.com"
	# end

	before do 
		@signup_dd = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_dd.inventories.create(itemlist_id: 1)
		@signup_jdong = Signup.create(email:"jdong8@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_jdong.inventories.create(itemlist_id: 1)

		@signup_ana = Signup.create(email: "anavarada@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_ngo = Signup.create(email: "ngomenclature@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_dance = Signup.create(email: "dancingknives@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_borrows = Signup.create(email: "borrowsapp@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
	end

	it "should have 2 inventories and 2 signups to start" do
		Signup.count.should == 6
		Inventory.count.should == 2
	end

	describe "request creation" do

		before do
			@newcategory = Categorylist.create(name: "Camping")
			@newcategory.itemlists.create(name: "2-Person tent", request_list: true)
			visit '/'
			fill_in 'signup_email1', :with => "anavarada@gmail.com"
			click_button 'signup1'
			click_button 'borrow'
			fill_in 'borrow__1', :with => 1
			select '2015', :from => 'request_pickupdate_1i'
			select 'January', :from => 'request_pickupdate_2i'
			select '1', :from => 'request_pickupdate_3i'
			select '2015', :from => 'request_returndate_1i'
			select 'January', :from => 'request_returndate_2i'
			select '5', :from => 'request_returndate_3i'
			click_button 'submit_request'
		end

		it "should affect new Requests and Borrows" do
			Borrow.count.should == 2
			Request.count.should == 1
		end

		it "should affect emails" do
			ActionMailer::Base.deliveries.size == 0
		end

		describe "affect accept/decline options" do
			before do 
				visit '/'
				fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
				click_button 'signup1'
				click_button 'lend'
				save_and_open_page
			end

			it "should have increased options for jamesdd9302" do 
				page.assert_selector("#manage", :count => 1)
			end
		end

		describe "affect accept/decline options" do
			before do 
				visit '/'
				fill_in 'signup_email1', :with => "jdong8@gmail.com"
				click_button 'signup1'
				click_button 'lend'
				save_and_open_page
			end

			it "should have increased options for jdong8" do 
				page.assert_selector("#manage", :count => 1)
			end
		end
	end
end