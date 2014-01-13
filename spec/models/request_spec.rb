require 'spec_helper'

describe Request do

  	before do
   		@request = Request.new(name: "James", email: "example@example.com", item: "Headlamp", detail: "camping")
  	end

    subject { @request }

  	it { should respond_to(:email) }
  	it { should respond_to(:item) }
  	it { should respond_to(:detail) }
  	it { should respond_to(:name) }
  	it { should respond_to(:edit_id) }

  	it { should be_valid }

	describe "when name is not present" do
    	before { @request.name = " " }
    	it { should_not be_valid }
 	end
  
	describe "when name is too long" do
	    before { @request.name = "a" * 51 }
	    it { should_not be_valid }
	end

  	describe "when email is not present" do
    	before { @request.email = " " }
    	it { should_not be_valid }
 	 end

    describe "when email format is invalid" do
   		it "should be invalid" do
	      	addresses = %w[user@foo..com, user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
	      	addresses.each do |invalid_address|
	        	@request.email = invalid_address
	        	expect(@request).not_to be_valid
	      	end
    	end
  	end

  	describe "when email format is valid" do
   		it "should be valid" do
	        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	        addresses.each do |valid_address|
        		@request.email = valid_address
       			expect(@request).to be_valid
      		end
    	end
  	end

  	describe "when item is not present" do
  		before { @request.item = "" }
  		it { should_not be_valid }
  	end

  	describe "when detail is not present" do
  		before { @request.detail = "" }
  		it { should be_valid }
  	end

end

