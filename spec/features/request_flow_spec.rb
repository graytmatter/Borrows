require 'spec_helper'

describe "how requests should flow" do

	before do 
		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(name: "2-Person tent", request_list: true)
		status_codes = {

		#First column: Did borrower use or not use Project Borrow?

		  "1 Did use PB" => [
		    "Checking", #Default status, assumes that PB will help
		    "Connected", #Automatically set if a connection is made between borrower and lender
		    "In progress", #Follows In Progress, automatically set on the Pick Up Date of Connected borrows, I have to manually adjust if one party informs me otherwise  
		    "Complete - OK", #Follows In Progress, automatically set on the Return Date, I have to manually adjust if one party tells me otherwise
		    "Complete - Disputing", #Follow In Progress, something went wrong
		    "Complete - Settled Informally", #Follows Complete - Disputing, indicates that some settlement was reached mediated by PB at most
		    "Complete - Settled Formally" #Follows Complete - Disputing, indicates that some settlement was reached that required legal action
		  ],

		  #What was the primary reason where, had it not been the case, the borrow would have happened and the borrower would have used PB?

		  #FC = False Cancel, with slight changes in circumstance, the borrow could have happend
		  #TC = True Cancel, very likely that the borrower would have cancelled no matter what changes in circumstance

		  "1 Did not use PB" => [
		    "FC - No response from borrower", #I have to manually set, e.g., if lender tells me
		    "FC - No response from lender", #Manual set or Auto set if the end of the pick up date comes up 
		    "FC - Borrower forgot last minute", #Manual set if one party informs me, E.g., borrower did not pick up at scheduled time, and didn't change the time
		    "FC - Lender forgot last minute", #Manual set if one party informs me, E.g., lender forgot to make item available at scheduled time, and didn't change the time
		    "FC - Scheduling conflict", #Manual set if one party informs me, 
		    "FC - Out of area", #Will build an auto check for this, but still manual set if someone tries to sneak it 
		    "FC - Inventory not suitable", #Manual set if one party informs me, E.g., specifications not met
		    "FC - Too inconvenient (time/money cost)", #Manual set if one party informs me, 
		    "FC - Found sale",

		    # Eventually this section should be all auto-set
		    "TC - Occasion for use cancelled",
		    "TC - Item not actually needed", #E.g., consumer education, water filters not needed for car camping
		    "TC - Mistaken or trial request", #E.g., didn't even mean to submit
		    "TC - Borrower already got it", #Auto-set E.g., borrow already connected with lender
		    "TC - Lender declined", #Auto-set E.g., lender cancels
		    "TC - Lender already gave it", #Auto-set E.g., lender already accepted someone else's request for a conflicitng time
		    "TC - Actually needs item frequently" #E.g., buying makes more sense
		  ]
		}
		status_codes.each do |c, s|
		  Statuscategory.create(name: c)
		  s.each do |s|
		    Statuscategory.find_by_name(c).statuses.create(name: s)
		  end
		end

		@signup_dd = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_jdong = Signup.create(email:"jdong8@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_ana = Signup.create(email: "anavarada@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_ngo = Signup.create(email: "ngomenclature@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_dance = Signup.create(email: "dancingknives@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)
		@signup_borrows = Signup.create(email: "borrowsapp@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: "94109", tos: true)

		@signup_dd.inventories.create(itemlist_id: 1)
		@signup_jdong.inventories.create(itemlist_id: 1)
	end
		
	it "should have 2 inventories and 2 signups to start" do
		Signup.count.should == 6
		Inventory.count.should == 2
	end

	describe "request creation" do

		before do
			# ApplicationController.stub(session[:signup_email]).and_return("anavarada@gmail.com")
			# visit '/requests/new'
			# save_and_open_page
			
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

		it "should affect Requests and Borrows" do
			Borrow.count.should == 2
			Borrow.where(status1: 1).count.should == 2
			Request.count.should == 1
		end

		it "should affect emails" do
			ActionMailer::Base.deliveries.size == 0
			#expect(mail.subject).to eql('Instructions')
		end

		it "should affect management options for jamesdd9302" do 
			visit '/'
			fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
			click_button 'signup1'
			click_button 'lend'

			page.assert_selector("#manage", :count => 1)
			page.assert_selector("#connected", :count => 0)
		end

		it "should affect management options for jdong8" do 
			visit '/'
			fill_in 'signup_email1', :with => "jdong8@gmail.com"
			click_button 'signup1'
			click_button 'lend'

			page.assert_selector("#manage", :count => 1)
			page.assert_selector("#connected", :count => 0)
		end

		describe "jamesdd9302 declines" do

			before do
				visit '/'
				fill_in 'signup_email1', :with => "jamesdd9302@yahoo.com"
				click_button 'signup1'
				click_button 'lend'
				click_link 'decline'
			end

			it "should affect Requests and Borrows" do
				Borrow.count.should == 2
				Borrow.where(status1: 1).count.should == 1
				Borrow.where(status1: 21).count.should == 1
				Request.count.should == 1
			end

			it "should affect emails" do
				ActionMailer::Base.deliveries.size == 0
				#expect(mail.subject).to eql('Instructions')
			end

			it "should affect management options for jamesdd9302" do 
				page.assert_selector("#manage", :count => 0)
				page.assert_selector("#connected", :count => 0)
			end

			it "should affect management options for jdong8" do 
				visit '/'
				fill_in 'signup_email1', :with => "jdong8@gmail.com"
				click_button 'signup1'
				click_button 'lend'

				page.assert_selector("#manage", :count => 1)
				page.assert_selector("#connected", :count => 0)
			end
		end
	end

end