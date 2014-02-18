require 'spec_helper'

describe 'static_pages/home.html.erb' do

  before :each do
    render template: "static_pages/home"
  end

  it 'displays image' do
  	rendered.should have_selector('.homepage')
  end

  it 'displays links to signup and request pages' do
  	rendered.should have_link("Cool idea - keep me posted!", href: new_signup_path)
  	rendered.should have_link("Let me try - I need something now!", href: new_request_path)  
  end

  it 'should not render layout (i.e., contain navbar)' do
  	rendered.should_not have_link("Home", href: root_path)
  	rendered.should_not have_selector('.navbar')
  end

  it 'should not have a form' do
    rendered.should_not have_selector('.form')
  end

  it 'should have a Google Analytics link' do
    rendered.should have_content('.google-analytics.com/')
  end

end