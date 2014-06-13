require 'spec_helper'

describe RequestsController do
	render_views

	before :all do
		@inventory = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter"],
      "Park & picnic" => ["Portable table", "Portable chair", "Cooler", "Outdoors grill", "Shade house"],
      "Tools" => ["Electric drill", "Screwdriver set", "Hammer", "Wrench set", "Utility knife"],
      "Housewares" => ["Vacuum", "Air mattress", "Iron & board", "Luggage", "Extension cords"], 
      #"Baby gear" => ["Umbrella Stroller", "Booster seat", "Backpack carrier", "Pack n' Play", "Jumper"],
      "Kitchenwares" =>["Blender", "Electric grill", "Food processor", "Baking dish", "Knife sharpener"],
      #"Snow sports" => ["Outerwear", "Innerwear", "Gloves" , "Helmet", "Goggles"]
      "Miscellaneous" => ["Tennis set", "Bike pump", "Jumper cables", "Dry bag", "Mat cutter"],
    }
	  #refactor so that this is unnecessary
	end

	describe "GET new" do
		it "creates a new request" do
			get :new
			assigns(:requestrecord).should be_a_new(Request)
			assert_select ('form')
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
			css_select ('error_explanation')
		end

		it "does not send mail" do
			expect{
				post :create, request: FactoryGirl.attributes_for(:invalid_request)
			}.to_not change(ActionMailer::Base.deliveries, :size)
		end

	end

	describe "PATCH edit/update" do

		before :each do
			@testrequest = FactoryGirl.create(:request, email: "jdong8@gmail.com")
		end
		
		it "located the requested @testrequest" do
			patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request)
			assigns(:requestrecord).should eq(@testrequest)
		end

		describe "using valid data" do

			it "updates the request" do
				patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, email: "jamesdd9302@yahoo.com")
				@testrequest.reload
				@testrequest.email.should eq("jamesdd9302@yahoo.com")
			end

			it "redirects to edit action" do
				patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, email: "jamesdd9302@yahoo.com")
				response.should redirect_to edit_request_url(assigns[:requestrecord].edit_id) 
			end

			it "sends mail" do
				expect{
					patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, email: "jamesdd9302@yahoo.com")
				}.to change(ActionMailer::Base.deliveries, :size).by(1)
			end
		end

		describe "using invalid data" do

			it "does not update the request" do
				patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, email: "jamesdd9302")
				@testrequest.reload
				@testrequest.email.should eq("jdong8@gmail.com")
			end

			it "re-renders edit action" do
				patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, email: "jamesdd9302")
				css_select ('error_explanation')
			end

			it "does not sends mail" do
				expect{
					patch :update, edit_id: @testrequest.edit_id, request: FactoryGirl.attributes_for(:request, email: "jamesdd9302")
				}.to_not change(ActionMailer::Base.deliveries, :size)
			end
		end

	end
end
