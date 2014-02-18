require 'spec_helper'

describe RequestsController do

	before :each do
		@inventory = {
	      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter", "Hydration bladder"],
	      "Housewares" => ["Air mattress", "Electric drill", "Suitcase", "Iron", "Blender", "Portable grill"],
	      "Snow sports" => ["Outer shell (upper)", "Outer shell (lower)", "Insular mid-layer (upper)", "Insular mid-layer(lower)", "Helmet", "Goggles"],
	      "City sports" => ["Tennis racket & balls", "Volleyball net & ball", "Football", "Bicycle", "Bicycle pump", "Bicycle helmet"]
	      }
	      #refactor so that this is unnecessary
	end

	describe "GET new" do
		it "creates a new request" do
			get :new
			assigns(:requestrecord).should be_a_new(Request)
		end
	end

	describe "POST create - with valid data" do

		it "creates a new request" do
			expect{
				post :create, request: FactoryGirl.attributes_for(:request)
			}.to change(Request,:count).by(1)
		end

		it "redirects to edit action" do
			post :create, request: FactoryGirl.attributes_for(:request)
			response.should redirect_to edit_request_url(assigns[:requestrecord].edit_id)  
		end


		it "sends mail" do
			expect{
				post :create, request: FactoryGirl.attributes_for(:request)
			}.to change(ActionMailer::Base.deliveries, :size).by(1)
		end

	end

	describe "POST create - with invalid data" do
		it "does not create a new request" do
			expect{
				post :create, request: FactoryGirl.attributes_for(:invalid_request)
			}.to_not change(Request,:count)
		end

		it "re-render new action" do
			post :create, request: FactoryGirl.attributes_for(:invalid_request)
			page.should render_template :new
		end

		it "does not send mail" do
			expect{
				post :create, request: FactoryGirl.attributes_for(:invalid_request)
			}.to_not change(ActionMailer::Base.deliveries, :size)
		end

	end

	describe "PATCH edit/update" do

		before :each do
			@testrequest = FactoryGirl.create(:request, name: "James Dong")
		end
		
		it "located the requested @testrequest" do
			patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request)
			assigns(:requestrecord).should eq(@testrequest)
		end

		describe "using valid data" do

			it "updates the request" do
				patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, name: "Larry Johnson")
				@testrequest.reload
				@testrequest.name.should eq("Larry Johnson")
			end

			it "redirects to edit action" do
				patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, name: "Larry Johnson")
				response.should redirect_to edit_request_url(assigns[:requestrecord].edit_id) #or to try @testrequest.edit_id
			end

			it "sends mail" do
				expect{
					patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, name: "Larry Johnson")
				}.to change(ActionMailer::Base.deliveries, :size).by(1)
			end
		end

		describe "using invalid data" do

			it "does not update the request" do
				patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, name: "Larry")
				@testrequest.reload
				@testrequest.name.should eq("James Dong")
			end

			it "re-renders edit action" do
				patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, name: "Larry")
				response.should render_template 'edit' 
			end

			it "does not sends mail" do
				expect{
					patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, name: "Larry")
				}.to_not change(ActionMailer::Base.deliveries, :size)
			end
		end

	end
end