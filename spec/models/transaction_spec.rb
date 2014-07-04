require 'spec_helper'

describe Transaction do

  	before do
   		@transaction = FactoryGirl.create(:transaction)
  	end

    subject { @transaction }

  	it { should respond_to(:request_id) }
  	it { should respond_to(:item_id) }
  	it { should respond_to(:name) }
  	it { should respond_to(:status) }

  	it { should be_valid }

    describe "request_id invalid tests" do
      before { @transaction.request_id = "" }
      it { should_not be_valid }
    end

    describe "item_id invalid tests" do
      before { @transaction.item_id = "" }
      it { should_not be_valid }
    end

    describe "name invalid tests" do
      before { @transaction.name = "" }
      it { should_not be_valid }
    end

end
