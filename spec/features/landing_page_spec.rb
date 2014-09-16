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

	describe "click on invite me link" do

		# before do
		# 	Capybara.current_driver = :selenium
		# 	visit "http://www.facebook.com" #seems like optiosn to visit external page are this selenium set up which is stuck at unable to connect to chromedriver OR to use Rack Test, which per beginning of this Test file I can't seem to define the app right in order to use the methods
		# 	save_and_open_page
		# end

		# it "shoudl" do
		# 	page.assert_selector("#random")
		# end

	end
end
