require 'spec_helper'

feature SignupsController, :type => :controller do
	render_views

	describe "new" do
		it "creates a new signup at @signup" do
			get :new
			assigns(:signup).should be_a_new(Signup)
			assert_select ('form')
		end
	end

	describe "create - with valid, new data" do
		it "creates a new signup" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:signup)
			}.to change(Signup,:count).by(1)
		end

		it "redirect to form page" do
			post :create, signup: FactoryGirl.attributes_for(:signup)
			response.should render_template "subscribe/notification_email"
			response.should redirect_to "/new"
		end

		it "sends an email" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:signup)
			}.to change(ActionMailer::Base.deliveries, :size).by(1)
		end

	end

	describe "create - with valid, existing data" do

		before do
			@somesignup = Signup.create(email: "jdong8@gmail.com")
  		end

		it "does not create a new signup" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:repeat_signup)
			}.to_not change(Signup,:count)
		end

		it "redirect to form page" do
			post :create, signup: FactoryGirl.attributes_for(:repeat_signup)
			response.should_not render_template "subscribe/notification_email"
			response.should redirect_to "/new"
		end

		it "does not send an email" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:repeat_signup)
			}.to_not change(ActionMailer::Base.deliveries, :size)
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
			response.should_not redirect_to "/new"
			css_select ('error_explanation')
		end

		it "does not send an email" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:invalid_signup)
			}.to_not change(ActionMailer::Base.deliveries, :size)
		end

	end


end
