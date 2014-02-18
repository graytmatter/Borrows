require 'spec_helper'

describe 'requests/edit.html.erb' do

  before :each do
      @requestrecord = FactoryGirl.create(:request)
      @inventory = {
      "Camping" => ["Tent", "Sleeping bag", "Sleeping pad", "Backpack", "Water filter", "Hydration bladder"],
      "Housewares" => ["Air mattress", "Electric drill", "Suitcase", "Iron", "Blender", "Portable grill"],
      "Snow sports" => ["Outer shell (upper)", "Outer shell (lower)", "Insular mid-layer (upper)", "Insular mid-layer(lower)", "Helmet", "Goggles"],
      "City sports" => ["Tennis racket & balls", "Volleyball net & ball", "Football", "Bicycle", "Bicycle pump", "Bicycle helmet"]
      }
      render
  end
# refactor, so that inventory is available in this test 

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

=begin
  it 'form should be pre-filled' do
    assert_select "form input" do
      assert_select "[name=?]", /.+/  # Not empty
    end
  end
=end

end

#more tests for the flash messages that should pop up if the @requestrecord is sBAD