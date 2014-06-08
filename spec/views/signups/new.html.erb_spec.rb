require 'spec_helper'

describe 'signups/new.html.erb' do

  it 'should have form' do
    assert_select "form"
  end

  it 'should have error messsages' do
    assign(:signup, FactoryGirl.build(:invalid_signup))
    visit '/signups/new'
    rendered.should have_selector('.error_explanation')
  end

end