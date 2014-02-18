require 'spec_helper'

describe 'signups/new.html.erb' do

  before :each do
    assign(:signup, FactoryGirl.build(:signup))
    render layout: "layouts/application", template: "signups/new"
  end

  it 'does not have background image' do
    rendered.should_not have_selector('.homepage')
  end

  it 'displays link to request pages not signup page' do
    rendered.should have_link("Make a new request", href: new_request_path)
    rendered.should_not have_link("Add me to the mailing list", href: new_signup_path)
  end

  it 'should render application layout (i.e., contain navbar)' do
    rendered.should have_selector('.navbar')
    rendered.should have_link("Home", href: root_path)
  end

  it 'should have form' do
    assert_select "form"
  end

  it 'all input fields in the form should have a name' do
    assert_select "form input" do
      assert_select "[name=?]", /.+/  # Not empty
    end
  end

end