require 'spec_helper'

describe Itemlist do
  	
  	before do
   		@itemlist = FactoryGirl.create(:itemlist)
  	end

    subject { @itemlist }

  	it { should respond_to(:categorylist_id) }
  	it { should respond_to(:name) }
  	it { should respond_to(:request_list) }
  	it { should respond_to(:inventory_list) }

  	it { should be_valid }

    describe "categorylist_id invalid tests" do
      before { @itemlist.categorylist_id = "" }
      it { should_not be_valid }
    end

    describe "name invalid tests" do
      before { @itemlist.name = "" }
      it { should_not be_valid }
    end

    describe "request/inventory list invalid tests" do
      
      describe "both are nil" do
	    before do 
	      	@itemlist.request_list = nil
	      	@itemlist.inventory_list = nil
	    end
      	it { should_not be_valid }
      end

      describe "both are false" do
	    before do 
	      	@itemlist.request_list = false
	      	@itemlist.inventory_list = false
	    end
      	it { should_not be_valid }
      end

    end

    describe "request/inventory list valid tests" do
      
      #request_list being true is already handled by original factory girl creation
      describe "both are true" do
	    before do 
	      	@itemlist.inventory_list = true
	    end
      	it { should be_valid }
      end

      describe "one is true" do
	    before do 
	      	@itemlist.request_list = false
	      	@itemlist.inventory_list = true
	    end
      	it { should be_valid }
      end
      
    end

end