require 'spec_helper'

describe "how signup check should work" do

	before do 
		@signup = Signup.create(email: "JDONG8@Gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")
	end
		
	it "should have 1 signup to start with a downcased email" do
		Signup.count.should == 1
		@signup.email.should == "jdong8@gmail.com"
	end

	describe "returning user login" do

		before do
			visit '/'
			fill_in 'signup_email1', :with => "jdong8@gmail.com"
			click_button 'signup1'
		end

		it "should not create a new Signup" do
			Signup.count.should == 1
			ActionMailer::Base.deliveries.size == 0
		end

		it "should render an edit page with only options, no form" do
			page.assert_no_selector('#edit_signup_form')
		end

	end

	describe "new user uses valid email" do

		before do
			visit '/'
			fill_in 'signup_email1', :with => "new@yahoo.com"
			click_button 'signup1'
		end

		it "should create a new Signup" do 
			Signup.count.should == 2
			ActionMailer::Base.deliveries.size == 1
			# expect(mail.subject).to eql(subject_line) unless subject_line == ''

			Signup.last.email.should == "new@yahoo.com"
		end

		it "should lead to full edit page" do
			#it's running edit errors on home page, not sure why, perhaps due to session routing issue?
			page.assert_selector('#edit_signup_form')
			page.assert_selector('#signup_streetone')
			page.assert_selector('#signup_streettwo')
			page.assert_selector('#signup_zipcode')
			page.assert_selector('#signup_tos')
		end

		describe "new user completes with valid info" do

			before do
				visit '/'
				fill_in 'signup_email1', :with => "new@yahoo.com"
				click_button 'signup1'
				fill_in 'signup_streetone', :with => "Post"
				fill_in 'signup_streettwo', :with => "Taylor"
				fill_in 'signup_zipcode', :with => 94109
				check 'signup_tos'
				click_button 'borrow'
			end

			it "should update the Signup, but not create a new one" do
				Signup.count.should == 2
				ActionMailer::Base.deliveries.size == 1

				Signup.last.streetone.should == "Post"
				Signup.last.streettwo.should == "Taylor"
				Signup.last.zipcode.should == 94109
				Signup.last.tos.should == true
			end

			it "should lead to borrow page" do #enough, don't need to also test the lend
				page.assert_selector('#new_request')
			end

		end

		describe "new user completes with invalid info" do

			before do
				visit '/'
				fill_in 'signup_email1', :with => "new@yahoo.com"
				click_button 'signup1'
				fill_in 'signup_streetone', :with => "Post"
				fill_in 'signup_streettwo', :with => "Taylor"
				fill_in 'signup_zipcode', :with => 94109
				click_button 'borrow'
			end

			it "should not update the Signup, and not create a new one" do
				Signup.count.should == 2
				ActionMailer::Base.deliveries.size == 1

				Signup.last.streetone.should == nil
				Signup.last.streettwo.should == nil
				Signup.last.zipcode.should == nil
				Signup.last.tos.should == nil
			end

			it "should refresh page and have errors" do #enough, don't need to also test the lend
				page.assert_selector('#edit_signup_form')
				page.assert_selector('#signup_streetone')
				page.assert_selector('#signup_streettwo')
				page.assert_selector('#signup_zipcode')
				page.assert_selector('#signup_tos')

				page.assert_selector('#error')
			end

		end

		describe "new user completes with out of area zip" do

			before do
				visit '/'
				fill_in 'signup_email1', :with => "new@yahoo.com"
				click_button 'signup1'
				fill_in 'signup_streetone', :with => "Post"
				fill_in 'signup_streettwo', :with => "Taylor"
				fill_in 'signup_zipcode', :with => 99999
				check 'signup_tos'
				click_button 'borrow'
			end

			it "should update the Signup, but not create a new one" do
				Signup.count.should == 2
				ActionMailer::Base.deliveries.size == 1

				Signup.last.streetone.should == "Post"
				Signup.last.streettwo.should == "Taylor"
				Signup.last.zipcode.should == 99999
				Signup.last.tos.should == true
			end

			it "should lead to root page" do
				page.assert_selector('#signup_email1')
				page.assert_selector('#info')
			end

		end
	end
end