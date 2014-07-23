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

  	it { should be_valid }

    describe "signup_id invalid tests" do
      before { @request.signup_id = "" }
      it { should_not be_valid }
    end

    describe "dates invalid tests" do

      describe "pickup date after return date" do
        before do 
          @request.pickupdate = DateTime.now + 5
          @request.returndate = DateTime.now + 2
        end

        it { should_not be_valid }
      end

      describe "blank dates" do
        before do 
          @request.pickupdate = nil
          @request.returndate = nil 
        end

        it { should_not be_valid }
      end

      describe "before today" do
        before do 
          @request.pickupdate = DateTime.now - 1
          @request.returndate = DateTime.now
        end

        it { should_not be_valid }
      end

      describe "too many days" do
        before do 
          @request.pickupdate = DateTime.now + 1
          @request.returndate = DateTime.now + 16
        end

        it { should_not be_valid }
      end

    end

    describe "dates valid test" do

      describe "same day" do
        before do 
          @request.pickupdate = DateTime.now
          @request.returndate = DateTime.now
        end

        it { should be_valid }
      end

      describe "exactly 14 days" do
        before do 
          @request.pickupdate = DateTime.now + 1
          @request.returndate = DateTime.now + 15
        end

        it { should be_valid }
      end

    end
end

