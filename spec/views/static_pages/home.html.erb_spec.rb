require 'spec_helper'

describe 'static_pages/home.html.erb' do
  it 'displays image' do
  	render template: "static_pages/home"
  	rendered.should have_selector('homepage')
  end

  it 'displays links to signup and request pages' do
  	render template: "static_pages/home"
  	rendered.should have_link(href: new_signup_path)
  	rendered.should have_link(href: new_request_path)
  end

  it 'should not render layout (i.e., contain navbar)' do
  	render template: "static_pages/home"
  	rendered.should_not have_link(href: root_path)
  	rendered.should_not have_selector('navbar')
  end

end