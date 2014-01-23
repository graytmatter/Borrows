require 'spec_helper'

describe 'signups/new.html.erb' do

  it 'does not have background image' do
    render 
    rendered.should_not have_selector('homepage')
  end

  it 'displays link to request pages not signup page' do
    render 
    rendered.should have_link(href: new_request_path)
    rendered.should_not have_link(href: new_signup_path)
  end

  it 'should render application layout (i.e., contain navbar)' do
    render
    rendered.should have_link(href: root_path)
    rendered.should have_selector('navbar')
  end

end