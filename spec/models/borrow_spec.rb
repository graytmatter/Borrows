require 'spec_helper'

describe borrow do

  	before do
   		@borrow = FactoryGirl.create(:borrow)
  	end

    subject { @borrow }

  	it { should respond_to(:request_id) }
  	it { should respond_to(:item_id) }
  	it { should respond_to(:name) }
  	it { should respond_to(:status) }

  	it { should be_valid }

    describe "request_id invalid tests" do
      before { @borrow.request_id = "" }
      it { should_not be_valid }
    end

    describe "name invalid tests" do
      before { @borrow.name = "" }
      it { should_not be_valid }
    end

end
