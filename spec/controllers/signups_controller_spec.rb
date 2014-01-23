require 'spec_helper'

describe SignupsController, :type => :controller do

	describe "new" do
		it "creates a new signup at @signup" do
			get :new
			assigns(:signup).should be_a_new(Signup)
		end
	end

	describe "create - with valid data" do
		it "creates a new signup" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:signup)
			}.to change(Signup,:count).by(1)
		end

		it "redirect to new action" do
			post :create, signup: FactoryGirl.attributes_for(:signup)
			response.should render_template :new
		end

	end

	describe "create - with invalid data" do
		it "does not create a new signup" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:invalid_signup)
			}.to_not change(Signup,:count)
		end

		it "re-renders new action" do
			post :create, signup: FactoryGirl.attributes_for(:invalid_signup)
			response.should render_template :new
		end

	end


end
