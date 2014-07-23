require 'spec_helper'

describe "how signup check should work" do

	before do 
		@signup = Signup.create(email: "JDONG8@Gmail.com")
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
			ActionMailer::Base.deliveries.size.should == 0
		end

		it "should render an edit page with only options, no form" do
			page.assert_selector('#edit_signup_form') == false
			page.assert_title("Welcome back")
		end

	end

	describe "new user uses valid email" do

		before do
			visit '/'
			fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
			click_button 'signup1'
			save_and_open_page
		end

		it "should create a new Signup" do 
			Signup.count.should == 2
			ActionMailer::Base.deliveries.size.should == 1
			# expect(mail.subject).to eql(subject_line) unless subject_line == ''

			Signup.last.email.should == "jamesdd9302@yahoo.com"
		end

		it "should lead to full edit page" do
			page.find('edit_signup_form')
			page.find('signup_streetone')
			page.find('signup_streettwo')
			page.find('signup_zipcode')
			page.find('signup_tos')
		end

		describe "new user completes with valid info" do

			before do
				visit '/'
				fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
				click_button 'signup1'
				fill_in 'signup_streetone', :with => "Post"
				fill_in 'signup_streettwo', :with => "Taylor"
				fill_in 'signup_zipcode', :with => 94109
				check 'signup_tos'
				click_button 'borrow'
			end

			it "should update the Signup, but not create a new one" do
				Signup.count.should == 2
				ActionMailer::Base.deliveries.size.should == 1

				Signup.last.streetone.should == "Post"
				Signup.last.streettwo.should == "Taylor"
				Signup.last.zipcode.should == 94109
				Signup.last.tos.should == true
			end

			it "should lead to borrow page" do #enough, don't need to also test the lend
				page.assert_title("What would you like to borrow?")
			end

		end

		describe "new user completes with invalid info" do

			before do
				visit '/'
				fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
				click_button 'signup1'
				fill_in 'signup_streetone', :with => "Post"
				fill_in 'signup_streettwo', :with => "Taylor"
				fill_in 'signup_zipcode', :with => 94109
				click_button 'borrow'
			end

			it "should not update the Signup, and not create a new one" do
				Signup.count.should == 2
				ActionMailer::Base.deliveries.size.should == 1

				Signup.last.streetone.should == nil
				Signup.last.streettwo.should == nil
				Signup.last.zipcode.should == nil
				Signup.last.tos.should == nil
			end

			it "should refresh page and have errors" do #enough, don't need to also test the lend
				page.find('edit_signup_form')
				page.find('signup_streetone')
				page.find('signup_streettwo')
				page.find('signup_zipcode')
				page.find('signup_tos')

				page.assert_selector('#error_explanation')
			end

		end
	end
end