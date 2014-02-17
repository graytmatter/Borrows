require 'spec_helper'

describe 'signups/new.html.erb' do

  it 'does not have background image' do
    assign(:signup, FactoryGirl.build(:signup))
    render template: "signups/new", layout: "layouts/application"
    rendered.should_not have_selector('homepage')
  end

  it 'displays link to request pages not signup page' do
    assign(:signup, FactoryGirl.build(:signup))
    render template: "signups/new", layout: "layouts/application"
    rendered.should have_link(href: "/new")
    #rendered.should_not have_link(href: "/signups/new")
  end

  it 'should render application layout (i.e., contain navbar)' do
    assign(:signup, FactoryGirl.build(:signup))
    render template: "signups/new", layout: "layouts/application"
    rendered.should have_selector('navbar')
    #rendered.should have_link(href: "/")
  end

end