require 'spec_helper'

describe "simple user flow" do
	
	# it "should prefill request page based on email entered in home page" do
	# 	Signup.create(email:"jdong8@gmail.com")
	# 	visit new_request_path
	# 	save_and_open_page
	# 	expect(page).to have_content "jdong8@gmail.com"
	# end

	it "should preserve original request information and carry it over to edit page" do
		visit new_request_path
		fill_in('Email we will use to contact you', :with => "jdong8@gmail.com")
		fill_in('Neighborhood', :with => "Tendernob")
		click_button('commit')
		save_and_open_page
		expect(page).to have_content "jdong8@gmail.com"
	end

end