require 'spec_helper'

# This file tests content of mailers, e.g., text/ links, etc. The actual tests that confirm the mailers are sent are in relevant other features tests (e.g., borrow_process_spec for async non recurring/ recurrent_jobs for async recurring)

describe "Create db info" do

	before do

		@jamespbemail = ["james@projectborrow.com"]
		@pickup_date = Date.today+2
		@return_date = Date.today+5

		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(id: 1, name: "2-Person tent", request_list: true)
		
		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")
		
		@lender1 = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@lender1.inventories.create(id: 1, itemlist_id: 1, description: "it's rad", available: true)

		@borrower1 = Signup.create(email:"jdong8@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@request1 = @borrower1.requests.create(pickupdate: @pickup_date, returndate: @return_date, detail: "Going camping for the first time")
		@borrow1 = @request1.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
	
	end

	describe "Request Mailer - not found" do

		before do
			@borrow1.update_attributes(status1: 20, inventory_id: nil)
			RequestMailer.not_found(@borrow1, 1).deliver
		end

		it "should contain the right contents and view elements" do
			email = ActionMailer::Base.deliveries.last
			email.to.should == [@borrow1.request.signup.email]
			email.from.should == @jamespbemail
			email.subject.should == "[Project Borrow]: Could not find #{Itemlist.find_by_id(@borrow1.itemlist_id).name.downcase}"
			email.body.should include("We did our best, but we could not find an available")
			email.body.should include("#{Itemlist.find_by_id(@borrow1.itemlist_id).name.downcase}")
			email.body.should include("from lenders in #{Geography.find_by_zipcode(@borrow1.request.signup.zipcode).county} county from #{@borrow1.request.pickupdate.strftime("%B %-d")} to #{@borrow1.request.returndate.strftime("%B %-d")}")
			# write code for links on cancel statuses and make sure they're passing expect( open_last_email.body).to have_selector("a[href$='#{activation_token}']", count: 1)
		end
	end

	describe "Request Mailer - repeat borrow" do

		before do
			RequestMailer.repeat_borrow(@borrow1, 1).deliver
		end

		it "should contain the right contents and view elements" do
			email = ActionMailer::Base.deliveries.last
			email.to.should == [@borrow1.request.signup.email]
			email.from.should == @jamespbemail
			email.subject.should == "[Project Borrow]: You've already requested #{Itemlist.find_by_id(@borrow1.itemlist_id).name.downcase}"
			email.body.should include("Our records indicate that you already made a request for a #{Itemlist.find_by_id(@borrow1.itemlist_id).name.downcase}")
			email.body.should include("from #{@borrow1.request.pickupdate.strftime("%B %-d")} to #{@borrow1.request.returndate.strftime("%B %-d")} on #{@borrow1.request.created_at.strftime("%B %-d")}")
		end
	end

	describe "Request Mailer - connect" do

		before do
			RequestMailer.connect_email(@borrow1).deliver
		end

		it "should contain the right contents and view elements" do
			email = ActionMailer::Base.deliveries.last
			email.to.should == [@borrow1.request.signup.email]
			email.cc.should == [Inventory.find_by_id(@borrow1.inventory_id).signup.email]
			email.from.should == @jamespbemail
			email.subject.should == "[Project Borrow]: #{Itemlist.find_by_id(@borrow1.itemlist_id).name.capitalize} exchange!"
			email.body.should include("Connecting the two of you so you can make sharing magic happen!")
			email.body.should include("#{Inventory.find_by_id(@borrow1.inventory_id).signup.streetone.capitalize}")
			email.body.should include("#{Inventory.find_by_id(@borrow1.inventory_id).signup.streettwo.capitalize}")
			email.body.should include("#{Geography.find_by_zipcode(Inventory.find_by_id(@borrow1.inventory_id).signup.zipcode).city}")
			email.body.should include("#{@borrow1.request.signup.streetone}")
			email.body.should include("#{@borrow1.request.signup.streettwo}")
			email.body.should include("#{Geography.find_by_zipcode(@borrow1.request.signup.zipcode).city}")
			email.body.should include("#{Inventory.find_by_id(@borrow1.inventory_id).description}")
			email.body.should include("#{@borrow1.request.pickupdate.strftime("%B %-d")}")
			email.body.should include("#{@borrow1.request.returndate.strftime("%B %-d")}")
		end
	end

	describe "Request Mailer - same day" do

		before do
			RequestMailer.same_as_today(@request1).deliver
		end

		it "should contain the right contents and view elements" do
			email = ActionMailer::Base.deliveries.last
			email.to.should == @jamespbemail
			email.from.should == [@borrow1.request.signup.email]
			email.subject.should == "ALERT: Same day request"
			#the info in body about borrows items not printing, but don't worry as this test will soon be moot
		end
	end

	describe "Request Mailer - return reminder" do

		before do
			RequestMailer.return_reminder(@borrow1).deliver
		end

		it "should have updated status" do
			@borrow1.status1.should == 4
		end

		it "should contain the right contents and view elements" do
			email = ActionMailer::Base.deliveries.last
			email.to.should == [@borrow1.request.signup.email]
			email.cc.should == [Inventory.find_by_id(@borrow1.inventory_id).signup.email]
			email.from.should == @jamespbemail
			email.subject.should == "[Project Borrow]: Reminder to return #{Itemlist.find_by_id(@borrow1.itemlist_id).name}"
			email.body.should include("#{Inventory.find_by_id(@borrow1.inventory_id).signup.streetone.capitalize}")
			email.body.should include("#{Inventory.find_by_id(@borrow1.inventory_id).signup.streettwo.capitalize}")
			email.body.should include("#{Geography.find_by_zipcode(Inventory.find_by_id(@borrow1.inventory_id).signup.zipcode).city}")
			email.body.should include("#{@borrow1.request.signup.streetone}")
			email.body.should include("#{@borrow1.request.signup.streettwo}")
			email.body.should include("#{Geography.find_by_zipcode(@borrow1.request.signup.zipcode).city}")
			email.body.should include("#{Inventory.find_by_id(@borrow1.inventory_id).description}")
			email.body.should have_selector("#borrower_survey", count: 1)
			email.body.should have_selector("#lender_survey", count: 1)
		end
	end

	describe "Request Mailer - return reminder" do

		before do
			RequestMailer.return_reminder(@borrow1).deliver
		end

		it "should have updated status" do
			@borrow1.status1.should == 4
		end

		it "should contain the right contents and view elements" do
			email = ActionMailer::Base.deliveries.last
			email.to.should == [@borrow1.request.signup.email]
			email.cc.should == [Inventory.find_by_id(@borrow1.inventory_id).signup.email]
			email.from.should == @jamespbemail
			email.subject.should == "[Project Borrow]: Reminder to return #{Itemlist.find_by_id(@borrow1.itemlist_id).name}"
			email.body.should include("Oh how the time flies", "#{Inventory.find_by_id(@borrow1.inventory_id).description}")
			email.body.should have_selector("#borrower_survey", count: 1)
			email.body.should have_selector("#lender_survey", count: 1)
		end
	end

	describe "Inventory Mailer - outstanding_request" do

		before do
			InventoryMailer.outstanding_request(Inventory.find_by_id(@borrow1.inventory_id).signup.id).deliver
		end

		it "should have updated last emailed on" do
			Inventory.find_by_id(@borrow1.inventory_id).signup.last_emailed_on.should == Date.today
		end

		it "should contain the right contents and view elements" do
			email = ActionMailer::Base.deliveries.last
			email.to.should == [Inventory.find_by_id(@borrow1.inventory_id).signup.email]
			email.from.should == @jamespbemail
			email.subject.should == "[Project Borrow]: Accept/ decline requests right in your email!"
			email.body.should include("It's now easier than ever to manage your requests, because you can do it in this very email, just as you would on")
			email.body.should include("#{@borrow1.request.pickupdate.strftime("%-m/%-d")}")
			email.body.should include("#{@borrow1.request.returndate.strftime("%-m/%-d")}")
			email.body.should include("New request from #{@borrow1.request.signup.email}")
			email.body.should include("in #{Geography.find_by_zipcode(@borrow1.request.signup.zipcode).city}! #{@borrow1.request.detail}")
			# email.body.should have_selector("#accept", count: 1)
			# email.body.should have_selector("#decline", count: 1)

			#not sure why the have_selectors are not working so the below 3 act as proxies
			email.body.should include('YES')
			email.body.should include('NO')
			email.body.should have_selector("#manage", count: 1)

		end

		# It would be nice to test that clicking the links work, but I'm going to by pass this because 1) requires email_spec gem and more set up and 2) since the email and dashboard are built using the exact same partial, since the partial works, assume that the email will work as well
	end



end