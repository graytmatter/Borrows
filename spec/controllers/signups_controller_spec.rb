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
				post :create, signup: FactoryGirl.attributes_for(:initial_signup)
			}.to change(Signup,:count).by(1)
		end

		it "redirect to edit page with a form" do
			post :create, signup: FactoryGirl.attributes_for(:initial_signup)
			response.should render_template "subscribe/notification_email"
			response.should redirect_to "/edit"
		end

		it "sends an email" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:initial_signup)
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

		it "redirect to edit page without a form" do
			post :create, signup: FactoryGirl.attributes_for(:repeat_signup)
			response.should_not render_template "subscribe/notification_email"
			response.should redirect_to "/edit"
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
				post :create, signup: FactoryGirl.attributes_for(:invalid_initial_signup)
			}.to_not change(Signup,:count)
		end

		it "re-renders new action" do
			post :create, signup: FactoryGirl.attributes_for(:invalid_initial_signup)
			response.should render_template :new
			response.should_not redirect_to "/"
			css_select ('error_explanation')
		end

		it "does not send an email" do
			expect{
				post :create, signup: FactoryGirl.attributes_for(:invalid_initial_signup)
			}.to_not change(ActionMailer::Base.deliveries, :size)
		end

	end

	describe "patch update" do

		before do
			@initial_signup = Signup.create(email: "jamesdd9302@yahoo.com")
  		end

  		it "should go to a page with a form if the signup is new" do
  			get :edit
  			asserts_select 'form'
  		end

  		it "should not go to a page with a form if the signup existed" do
  			@somesignup = Signup.create(email: "jamesdd9302@yahoo.com")
  			get :edit
  			asserts_select 'form', false
  		end

  		it "gets the right @signup" do
			patch :update, id: @initial_signup, signup: FactoryGirl.attributes_for(:initial_signup) 
			assigns(:initial_signup).should eq(@initial_signup)
		end

		describe "with valid data" do

			it "changes @signup's attributes and redirect_to inventories or requests form" do
				patch :update, id: @initial_signup, signup: FactoryGirl.attributes_for(:initial_signup, tos: true, streetone: "Post", streettwo: "Taylor", zipcode: "94109")
				@initial_signup.reload
				@initial_signup.tos = true
				@initial_signup.streetone = "Post"
				@initial_signup.streettwo = "Taylor"
				@initial_signup.zipcode = "94109"
				response.should redirect_to "requests/new" || "inventories/new" 
				assert_select ( 'form' )
			end
		end

		describe "with invalid data" do

			it "does not update @signup's attributes and re-renders edit" do
				patch :update, id: @initial_signup, signup: FactoryGirl.attributes_for(:initial_signup, tos: false, streetone: "Post", streettwo: "Taylor", zipcode: "909")
				@initial_signup.reload
				@initial_signup.tos = nil
				@initial_signup.streetone = nil
				@initial_signup.streettwo = nil
				@initial_signup.zipcode = nil
				response.should render_template :edit
				assert_select ( 'form' )
			end
		end
	end
end
