require 'spec_helper'


describe Request do

  	before do
   		@request = FactoryGirl.create(:request)
  	end

    subject { @request }

  	it { should respond_to(:email) }
  	it { should respond_to(:items) }
  	it { should respond_to(:addysdeliver) }
  	it { should respond_to(:startdate) }
    it { should respond_to(:enddate) }
  	it { should respond_to(:edit_id) } #model logic auto-creates this

  	it { should be_valid }

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

      before { @request.email = Faker::Internet.email }
      it { should be_valid }
  	end

  	describe "when item is not present" do
  		before { @request.items = ["0"] }
  		it { should_not be_valid }
  	end

    describe "when item is present" do
      before { @request.items = ["random"] }
      it { should be_valid }
    end

    describe "when startdate is after enddate" do
      before do 
        @request.startdate = DateTime.new(2014, 6, 3)
        @request.enddate = DateTime.new(2014, 5, 2)
      end

      it { should_not be_valid }
    end

    describe "when startdate is before enddate" do
      before do 
        @request.startdate = DateTime.new(2014, 6, 3)
        @request.enddate = DateTime.new(2014, 6, 9)
      end

      it { should be_valid }
    end

    describe "when startdate is the same as enddate" do
      before do 
        @request.startdate = DateTime.new(2014, 6, 3)
        @request.enddate = @request.startdate
      end

      it { should be_valid }
    end
end

