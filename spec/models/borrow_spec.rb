require 'spec_helper'

describe "Borrows" do

  	before do
   		@borrow = FactoryGirl.create(:borrow)
  	end

    subject { @borrow }

  	it { should respond_to(:request_id) }
  	it { should respond_to(:itemlist_id) }
  	it { should respond_to(:status1) }
    it { should respond_to(:status2)}
    it { should respond_to(:inventory_id)}
    it { should respond_to(:multiple)}

  	it { should be_valid }

    describe "request_id invalid tests" do
      before { @borrow.request_id = "" }
      it { should_not be_valid }
    end

    describe "itemlist_id invalid tests" do
      before { @borrow.itemlist_id = "" }
      it { should_not be_valid }
    end

    describe "status1 invalid tests" do
      before { @borrow.status1 = "" }
      it { should_not be_valid }
    end

    describe "multiple invalid tests" do
      before { @borrow.multiple = "" }
      it { should_not be_valid }
    end

end
