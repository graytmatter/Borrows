require 'spec_helper'
# This file tests content of mailers, e.g., text/ links, etc. The actual tests that confirm the mailers are sent are in relevant other features tests (e.g., borrow_process_spec for async non recurring/ recurrent_jobs for async recurring)
# require 'rack/test'
# include Rack::Test::Methods
# def app
# 	GoogleTest.new
# end

describe "Landing page flows" do

	before do
		visit '/'
	end

	it "should have video" do
		page.assert_selector("#video")
	end

	it "should have invite link" do
		page.assert_selector("#invite_me")
	end

	it "should have photopile" do
		page.assert_selector("#photopile_div")
	end

	it "should have link for original users" do
		page.assert_selector("#original")
	end

	it "should have invisible modals" do
		page.assert_selector("#submit_modal", visible: false)
		page.assert_selector("#warning_modal", visible: false)
	end

	describe "click on invite me link" do

		# 1) if you're not logged into facebook it prompts you to log in, then (or if you already are, it goes automatically to authorize)
  #   2) if you cancel out OR if you uncheck friend, you get the warning modal
  #   3) you can click back into the invite on warning modal as many times as you want to make a decision
  #   4) if you click OK with everything appropriate checked, then
  #     a) if your email was already in our database, the odl Signup is updated with the relevant info
  #     b) if your email is totally new, a new record is created with the relevant info
  #   5) At the end of either 4a or 4b, you see the success modal, and that hidden field tag has appropriate id
      
		# # before do
		# 	Capybara.current_driver = :selenium
		# 	visit "http://www.facebook.com" #seems like optiosn to visit external page are this selenium set up which is stuck at unable to connect to chromedriver OR to use Rack Test, which per beginning of this Test file I can't seem to define the app right in order to use the methods
		# 	save_and_open_page
		# end

		# it "shoudl" do
		# 	page.assert_selector("#random")
		# end

	end
end
