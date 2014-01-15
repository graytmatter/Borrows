require 'spec_helper'

describe "Requests" do
 
	subject { page }
  let(:submit) { "Go!" }

	describe "new request" do
		before { visit root_path }
		it { should have_content("What would you like to borrow?")}

		describe "with invalid information" do
			it "should not create request" do
				expect { click_button submit }.not_to change(Request, :count) 
	   		expect { click_button submit }.not_to change(ActionMailer::Base.deliveries, :size)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Email",        with: "example@example.com"
        		fill_in "Name",         with: "James"
        		choose "request_item_headlamp" 
      end

      		it "should create a request, redirect to edit page, and send mail" do
      			expect { click_button submit }.to change(Request, :count).by(1)
      			expect { click_button submit }.to change(ActionMailer::Base.deliveries, :size).by(1)
      			
      			before { click_button submit }
            it { should have_content("Update your request") }

      			subject { ActionMailer::Base.deliveries.last }
        		its(:subject) { should have_content == "Update link inside." }
      		end

      	end
  end

    describe "edit request" do
		before do
			  visit root_path
			  fill_in "Email",        with: "example@example.com"
    		fill_in "Name",         with: "James"
    		choose "request_item_headlamp" 
    		click_button submit
    		visit edit_request_path(request.edit_id)
    end

  		it { should have_content("James") }
  		it { should have_content("example@example.com") }

  		describe "with invalid info" do
  			before do
  				fill_in "Email", 	with: "d"
  				fill_in "Name", 	with: ""
  				click_button submit
  			end

  			it { should have_content("errors") }
  			it { should have_content("James") }
  			it { should have_content("example@example.com") }
  			it { should_not have_content("d") }
  		end

  		describe "witih valid info" do
  			before do
  				fill_in "Email", 	with: "replace@example.com"
  				fill_in "Name", 	with: "Dong"
  				click_button submit
  			end

  			it { should_not have_content("errors") }
  			it { should_not have_content("example@example.com") }
  			it { should_not have_content("James") }
  			it { should have_content("replace@example.com") }
  			it { should have_content("Dong") }
  		end
  	end
end


