require 'spec_helper'

describe Request do

  	before do
   		@request = FactoryGirl.create(:request)
  	end

    subject { @request }

  	it { should respond_to(:signup_id) }
  	it { should respond_to(:detail) }
  	it { should respond_to(:pickupdate) }
    it { should respond_to(:returndate) }
  	it { should respond_to(:edit_id) } #model logic auto-creates this

    it { should have_many(:transactions) }
    it { should belong_to(:signup) }
  	it { should be_valid }

    describe "signup_id invalid tests" do
      before { @request.signup_id = "" }
      it { should_not be_valid }
    end

    describe "dates invalid tests" do
      #pickup date after return date
      before do 
        @request.pickupdate = DateTime.new(2014, 6, 3)
        @request.returndate = DateTime.new(2014, 5, 2)
      end

      it { should_not be_valid }
    end

    describe "dates valid test" do
      #same day
      before do 
        @request.pickupdate = DateTime.new(2014, 6, 3)
        @request.returndate = @request.pickupdate
      end

      it { should be_valid }
    end
end

