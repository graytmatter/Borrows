require 'spec_helper'

describe 'requests/new.html.erb' do

  before :each do
      @requestrecord = FactoryGirl.create(:request)
      render
  end

  it 'does not have background image' do
    rendered.should_not have_selector('.homepage')
  end

  it 'displays link to request and signup pages' do
    rendered.should have_link("Make a new request", href: new_request_path)
    rendered.should have_link("Add me to the mailing list", href: new_signup_path)
  end

  it 'should render application layout (i.e., contain navbar)' do
    rendered.should have_link("Home", href: root_path)
    rendered.should have_selector('.navbar')
  end

  it 'should have form' do
    assert_select "form"
  end

  it 'form input fields should have a name' do
    assert_select "form input" do
      assert_select "[name=?]", /.+/  # Not empty
    end
  end


end

#more tests for the flash messages that should pop up if the @requestrecordrecord is sBAD