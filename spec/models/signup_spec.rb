require 'spec_helper'


describe Signup do

  	before do
   		@signup = FactoryGirl.create(:signup)
  	end

    subject { @signup }

  	it { should respond_to(:email) }
  	it { should respond_to(:name) }
  	it { should respond_to(:heard) }

  	it { should be_valid }

	describe "when name is not present" do
    	before { @signup.name = " " }
    	it { should_not be_valid }
 	end
  
	describe "when name is too long" do
	    before { @signup.name = "a" * 51 }
	    it { should_not be_valid }
	end

	describe "when there is only a first name" do
		before { @signup.name = Faker::Name.first_name }
		it { should_not be_valid }
	end

	describe "when there is only a last name" do
		before { @signup.name = Faker::Name.last_name }
		it { should_not be_valid }
	end

	describe "when there is an appropriate first and last name" do
		before { @signup.name = Faker::Name.name }
		it { should be_valid }
	end

  	describe "when email is not present" do
    	before { @signup.email = " " }
    	it { should_not be_valid }
 	 end

    describe "when email format is invalid" do
   		it "should be invalid" do
	      	addresses = %w[user@foo..com, user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
	      	addresses.each do |invalid_address|
	        	@signup.email = invalid_address
	        	expect(@signup).not_to be_valid
	      	end
    	end
  	end

  	describe "when email format is valid" do
   		it "should be valid" do
	        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	        addresses.each do |valid_address|
        		@signup.email = valid_address
       			expect(@signup).to be_valid
      		end
    	end

    	before { @signup.email = Faker::Internet.email }
		  it { should be_valid }

  	end

  	describe "when heard is not present" do
  		before { @signup.heard = "" }
  		it { should be_valid }
  	end

  	describe "when heard is present" do
  		before { @signup.heard = "random text" }
  		it { should be_valid }
  	end

end

