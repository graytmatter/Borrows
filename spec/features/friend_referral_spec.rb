require 'spec_helper'

describe "Friend referral emails", job: true do

	before do
		visit '/'
		Signup.create(email:"jamesdd9302@yahoo.com")
		Invitee.create(id: 1, email:"jdong8@gmail.com", sent: true)
		Invitee.create(id: 2, email:"jamesdong.photo@gmail.com", sent: false)
	end

	it "should have modal" do
		page.assert_selector("#submit_modal", visible: false)
		page.assert_selector("#referral_form", visible: false)
	end

	describe "enter existing signup email into referral_form" do

		before do 
			# controller.instance_eval{flash.stub!(:sweep)}
			# flash[:new_signup_fb_id] = 12345
			# visit '/'
			# instance_eval{flash.stub!(:sweep)}
   		
			# flash[:new_signup_fb_id] = 12345
			# flash.stub! :sweep
			# post :create, params, flash: flash
			fill_in "friend_emails", :with => "jamesdd9302@yahoo.com"
			click_button "refer" 
		end

		it "should not have create new invitee" do
			Signup.find_by_email("jamesdd9302@yahoo.com") == 1
			Invitee.find_by_email("jamesdd9302@yahoo.com") == 0
		end

		it "should not have sent an invitation email" do
			ActionMailer::Base.deliveries.size == 0
		end

		it "should have redirected to home page" do
			page.assert_selector("#invite_me")
			expect(page).to	have_content("Thanks for spreading the word!")
		end

	end

	describe "enter existing invitee email, but sent: false into referral_form" do

		before do
			fill_in "friend_emails", :with => "jamesdong.PHOTO@gmail.com"
			click_button "refer" 
		end

		it "should not have created a new invitee" do
			Signup.find_by_email("jamesdong.photo@gmail.com") == 0
			Invitee.find_by_email("jamesdong.photo@gmail.com") == 1
		end			

		it "should have sent an email and updated invitee status" do
			ActionMailer::Base.deliveries.size == 1
			ActionMailer::Base.deliveries.last.subject.should include("Invitation")
			Invitee.find_by_email("jamesdong.photo@gmail.com").sent == true
		end

		it "should have redirected to home page" do
			page.assert_selector("#invite_me")
			expect(page).to	have_content("Thanks for spreading the word!")
		end

	end

	describe "enter existing invitee email, but sent: true into referral_form" do

		before do
			fill_in "friend_emails", :with => "jDONG8@gmail.com"
			click_button "refer" 
		end

		it "should not have created a new invitee" do
			Signup.find_by_email("jdong8@gmail.com") == 0
			Invitee.find_by_email("jdong8@gmail.com") == 1
		end			

		it "should not have sent an email" do
			ActionMailer::Base.deliveries.size == 0
		end

		it "should have redirected to home page" do
			page.assert_selector("#invite_me")
			expect(page).to	have_content("Thanks for spreading the word!")
		end

	end

	describe "enter new invitee emails into referral_form" do

		before do
			fill_in "friend_emails", :with => "ANAvarada@gmail.com, NGOmenclature@gmail.com,jamesdd9302@yahoo.com,dancingKNIVES@YAHOO.COM"
			click_button "refer" 
		end

		it "should have created some new invitees" do
			Signup.find_by_email("anavarada@gmail.com") == 0
			Invitee.find_by_email("anavarada@gmail.com") == 1
			Invitee.find_by_email("anavarada@gmail.com").referer == 123

			Signup.find_by_email("jamesdd9302@yahoo.com") == 1
			Invitee.find_by_email("jamesdd9302@yahoo.com") == 0

			Signup.find_by_email("dancingknives@yahoo.com") == 0
			Invitee.find_by_email("dancingknives@yahoo.com") == 1
			Invitee.find_by_email("dancingknives@yahoo.com").referer == 123

			Signup.find_by_email("ngomenclature@gmail.com") == 0
			Invitee.find_by_email("ngomenclature@gmail.com") == 1
			Invitee.find_by_email("ngomenclature@gmail.com").referer == 123
		end			

		it "should have sent an email and updated invitee status" do
			ActionMailer::Base.deliveries.size == 3
			
			#last email
			ActionMailer::Base.deliveries.last.subject.should include("Invitation")
			
			#second to last email
		  index = ActionMailer::Base.deliveries.length - 2
			ActionMailer::Base.deliveries[index].subject.should include("Invitation")
				
			#third to last email
		  index = ActionMailer::Base.deliveries.length - 3
			ActionMailer::Base.deliveries[index].subject.should include("Invitation")

			Invitee.find_by_email("anavarada@gmail.com").sent == true
			Invitee.find_by_email("ngomenclature@gmail.com").sent == true
			Invitee.find_by_email("dancingknives@yahoo.com").sent == true
		end

		it "should have redirected to home page" do
			page.assert_selector("#invite_me")
			expect(page).to	have_content("Thanks for spreading the word!")
		end

	end

	describe "enter nothing into referral_form" do

		before do
			fill_in "friend_emails", :with => ""
			click_button "refer" 
		end

		it "should not have created a new invitee" do
			Signup.count == 1
			Invitee.count == 2
		end			

		it "should not have sent an email" do
			ActionMailer::Base.deliveries.size == 0
		end

		it "referral_form should still be visible" do
			page.assert_selector("#referral_form")
		end

		it "should not have success message" do
			expect(page).to_not	have_content("Thanks for spreading the word!")
		end

	end

	describe "enter at least one email with bad form into referral_form" do

		before do
			fill_in "friend_emails", :with => "valid_email@example.com, asf"
			click_button "refer" 
		end

		it "should not have created a new invitee" do
			Signup.count == 1
			Invitee.count == 2
		end			

		it "should not have sent an email" do
			ActionMailer::Base.deliveries.size == 0
		end

		it "referral_form should still be visible" do
			page.assert_selector("#referral_form")
		end

		it "should not have success message" do
			expect(page).to_not	have_content("Thanks for spreading the word!")
		end

	end

end
