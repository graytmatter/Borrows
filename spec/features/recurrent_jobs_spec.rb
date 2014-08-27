# require 'spec_helper'

# #None of these tests will work because 1) just beacuse the date is stubbed, there's nothing telling the server to run the recurring jobs on that date because sucker punch async tests aren't synchronizing and because even if they were fist of fury would still need to do something to enable testing to check that the code is actually run 

# describe "recurring jobs managed by Fist of Fury" do

# 	before do
# 		@jamespbemail = ["james@projectborrow.com"]
# 		@pickup_date = Date.today+10
# 		@return_date = Date.today+12

# 		@newcategory = Categorylist.create(name: "Camping")
# 		@newcategory.itemlists.create(id: 1, name: "2-Person tent", request_list: true)
		
# 		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")
		
# 		@lender1 = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true, last_emailed_on: Date.today)
# 		@lender1.inventories.create(id: 1, itemlist_id: 1, description: "it's rad", available: true)

# 		@borrower1 = Signup.create(email:"jdong8@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
# 		@request1 = @borrower1.requests.create(pickupdate: @pickup_date, returndate: @return_date, detail: "Going camping for the first time")
# 		@borrow1 = @request1.borrows.create(multiple: 1, status1: 1, itemlist_id: 1, inventory_id: 1)
# 	end

# 	describe "no response" do

# 		before do
# 			Date.stub(:today).and_return(@pickup_date+1)
# 		end

# 		it "should have auto updated the borrow's status" do
# 			@borrow1.status1.should == 9
# 		end

# 		it "should have sent a no response email" do
# 			ActionMailer::Base.deliveries.size == 1
# 			ActionMailer::Base.deliveries.last.subject.should include("not find")
# 		end

# 	end

# 	describe "in progress" do

# 		before do
# 			@borrow1.update_attributes(status1: 2)
# 			Date.stub(:today).and_return(@pickup_date+1)
# 		end

# 		it "should have auto updated the borrow's status" do
# 			@borrow1.status1.should == 3
# 		end

# 		it "should not have sent emails" do
# 			ActionMailer::Base.deliveries.size == 0
# 		end

# 		describe "complete" do

# 			before do
# 				Date.stub(:today).and_return(@return_date+1)
# 			end

# 			it "should have auto updated the borrow's status" do
# 				@borrow1.status1 == 4
# 			end

# 			it "should have sent return reminder email" do
# 				ActionMailer::Base.deliveries.size == 1
# 				ActionMailer::Base.deliveries.last.subject.should include("Reminder to return")
# 			end

# 		end

# 	end

# 	describe "outstanding request 1st email" do

# 		before do
# 			Date.stub(:today).and_return(Date.today+1)
# 		end

# 		it "should have sent outstanding email" do
# 			ActionMailer::Base.deliveries.size == 1
# 			ActionMailer::Base.deliveries.last.subject.should include("Accept")
# 		end

# 		it "should have updated the last emailed on" do
# 			@borrow1.request.signup.last_emailed_on == Date.today+1
# 		end

# 		describe "2nd email" do

# 			before do
# 				Date.stub(:today).and_return(Date.today+3)
# 			end

# 			it "should have sent outstanding email" do
# 				ActionMailer::Base.deliveries.size == 2
# 				ActionMailer::Base.deliveries.last.subject.should include("Accept")
# 			end

# 			it "should have updated the last emailed on" do
# 				@borrow1.request.signup.last_emailed_on == Date.today+3
# 			end
# 		end
# 	end
		
# end

# 			