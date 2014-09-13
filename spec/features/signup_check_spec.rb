require 'spec_helper'

describe "how signup check should work" do

	before do 
		@signup = Signup.create(email: "JDONG8@Gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: false, created_at: "2014-07-29 21:49:24")
		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")
	end
		
	it "should have 1 signup to start with a downcased email" do
		Signup.count.should == 1
		@signup.email.should == "jdong8@gmail.com"
	end

	describe "returning user login" do

		before do
			visit '/original'
			fill_in 'signup_email1', :with => "jdong8@gmail.com"
			check 'tos'
			click_button 'borrow'
		end

		it "should not create a new Signup" do
			Signup.count.should == 1
			ActionMailer::Base.deliveries.size == 0
		end

		it "should update timestamp and tos" do
			@found_signup = Signup.find_by_email("jdong8@gmail.com")
			@found_signup.tos == true
			@found_signup.update_at == Time.now
		end

		it "should render new request page successfully" do
			page.assert_no_selector('#new_request')
		end

	end

	describe "new user uses valid email and tos" do

		before do
			visit '/original'
			fill_in 'signup_email1', :with => "new@yahoo.com"
			check 'tos'
			click_button 'borrow'
		end

		it "should not create a new Signup" do 
			Signup.count.should == 1
			ActionMailer::Base.deliveries.size == 0
			Signup.last.email.should == "jdong8@gmail.com"
		end

		it "should re-render original page" do
			#it's running edit errors on home page, not sure why, perhaps due to session routing issue?
			page.assert_selector('#signup_email1')
			page.assert_selector('#danger')
		end

	end
end