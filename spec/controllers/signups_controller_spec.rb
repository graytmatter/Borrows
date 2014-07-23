require 'spec_helper'

feature SignupsController, :type => :controller do
	render_views

	before do 
		@signup = Signup.create(email: "JDONG8@Gmail.com")
		email = @signup.email
	end

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
				post :create, signup: FactoryGirl.attributes_for(:signup_email)
			}.to change(Signup,:count).by(1)
		end

		it "redirect to edit page" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:signup_email)
			}.to redirect_to "/edit"
		end

		it "sends an email" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:signup_email)
			}.to render_template "signup_mailer/notification_email"
			expect{
				post :create, signup: FactoryGirl.attributes_for(:signup_email)
			}.to change(ActionMailer::Base.deliveries, :size).by(1)
		end

	end

	describe "create - with valid, existing data" do

		it "cannot create a new signup" do
			Signup.create(email: email).to raise_error
		end

		it "redirect to edit page" do
			expect {Signup.new(email: "jdong8@gmail.com")}.to_not render_template "signup_mailer/notification_email"
			expect {Signup.new(email: "jdong8@gmail.com")}.to redirect_to "/edit"
		end

		it "does not send an email" do
			expect {Signup.new(email: "jdong8@gmail.com")}.to_not change(ActionMailer::Base.deliveries, :size)
		end

	end

	describe "create - with invalid data" do
		it "does not create a new signup" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:invalid_signup_email)
			}.to_not change(Signup,:count)
		end

		it "re-renders new action" do
			post :create, signup: FactoryGirl.attributes_for(:invalid_signup_email)
			response.should render_template :new
			response.should_not redirect_to "/new"
			css_select ('error_explanation')
		end

		it "does not send an email" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:invalid_signup_email)
			}.to_not change(ActionMailer::Base.deliveries, :size)
		end
	end
end