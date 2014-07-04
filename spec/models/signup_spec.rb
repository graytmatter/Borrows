require 'spec_helper'


describe Signup do

  subject { @signup }

  describe "mimic create action" do

  	before do
   		@signup = FactoryGirl.build(:signup)
  	end

  	it { should respond_to(:email) }

    it { should be_valid }

  	describe "email invalid tests" do
      # blank email
  	  before { @signup.email = " " }
      it { should_not be_valid }

      # invalid format email
      addresses = %w[user@foo..com, user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        before { @signup.email = invalid_address }
        it { should_not be_valid }
    end

    describe "email valid tests" do 
      #valid format 
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
    		before { @signup.email = valid_address }
   			it { should be_valid }
  		end
    end
  end

  describe "mimic update action" do

    before do
      @signup = FactoryGirl.create(:signup)
    end

    it { should respond_to(:email) }
    it { should respond_to(:streetone) }
    it { should respond_to(:streettwo) }
    it { should respond_to(:zipcode) }
    it { should respond_to(:heard) }
    it { should respond_to(:tos) }
    
    it { should be_valid }

    describe "cross streets invalid tests" do
      before { @signup.streetone = " " }
      it { should_not be_valid }

      before { @signup.streettwo = " " } 
      it { should_not be_valid }
      
      before { @signup.streetone = "Post" }
      before { @signup.streetone = @signup.streettwo }
      it { should_not be_valid }
    end

    describe "zipcode invalid tests" do
      before { @signup.zipcode = " " }
      it { should_not be_valid }
      
      before { @signup.zipcode = "asdfd" }
      it { should_not be_valid }
      
      before { @signup.zipcode = "123" }
      it { should_not be_valid }
      
      before { @signup.zipcode = "-123asdf" }
      it { should_not be_valid }
      
      before { @signup.zipcode = "-12345" }
      it { should_not be_valid }
      
      before { @signup.zipcode = "-1234" }
      it { should_not be_valid }
    end

    describe "zipcode valid tests" do
      #testing trim function to remove excessive spacing
      before { @signup.zipcode = " 94109 " }
      it { should be_valid }
    end

    describe "tos invalid tests" do
      before { @signup.tos = "" }
      it { should_not be_valid }

      before { @signup.tos = false }
      it { should_not be_valid }
    end
  end
end

end
