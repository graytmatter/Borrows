require 'spec_helper'

describe "how request submission should work" do

	before do 
		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(name: "2-Person tent", request_list: true)

		@signup = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup.inventories.create(itemlist_id: 1)
	end
		
	it "should have 0 requests and 1 signups to start" do
		Signup.count.should == 1
		Request.count.should == 0
	end

	describe "A) request creation" do

		before do
			visit '/'
			fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
			click_button 'signup1'
			click_button 'borrow'
		end

		it "should have inventory form" do
			page.assert_selector("#new_request")
		end

		describe "B) submit nothing" do
			before do
				fill_in 'borrow__1', :with => 0
				click_button 'submit_request'
			end

			it "should not create request" do
				Request.count.should == 0
			end

			it "should rerender page with errors" do
				page.assert_selector("#new_request")
				page.assert_selector("#error")
			end
		end

		describe "C) submit item, but not date" do
			before do
				fill_in 'borrow__1', :with => 2
				click_button 'submit_request'
			end

			it "should not create request" do
				Request.count.should == 0
			end

			it "should rerender page with errors" do
				page.assert_selector("#new_request")
				page.assert_selector("#error")
			end
		end

		describe "D) submit date, but not item" do
			before do
				select '2015', :from => 'request_pickupdate_1i'
				select Date::MONTHNAMES[Date.today.month], :from => 'request_pickupdate_2i'
				select Date.today.day, :from => 'request_pickupdate_3i'
				select '2015', :from => 'request_returndate_1i'
				select Date::MONTHNAMES[Date.today.month], :from => 'request_returndate_2i'
				select Date.today.day + 5, :from => 'request_returndate_3i'
				click_button 'submit_request'
			end

			it "should not create request" do
				Request.count.should == 0
			end

			it "should rerender page with errors" do
				page.assert_selector("#new_request")
				page.assert_selector("#error")
			end
		end

		describe "E) submit correctly" do

			before do
				fill_in 'borrow__1', :with => 2
				select '2015', :from => 'request_pickupdate_1i'
				select Date::MONTHNAMES[Date.today.month], :from => 'request_pickupdate_2i'
				select Date.today.day, :from => 'request_pickupdate_3i'
				select '2015', :from => 'request_returndate_1i'
				select Date::MONTHNAMES[Date.today.month], :from => 'request_returndate_2i'
				select Date.today.day + 5, :from => 'request_returndate_3i'
				click_button 'submit_request'
			end

			it "should create request" do
				Request.count.should == 1
				Borrow.count.should == 2
				Request.first.borrows.count.should == 2

			end

			it "should redirect to success page" do
				page.assert_selector("#relax")
			end

		end
	end
end

			