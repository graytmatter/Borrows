module Generating_oauth

	def get_oauth
		if Rails.env == "production"
			callback_url = "http://www.projectborrow.com/facebook_auth"
		else
			callback_url = "http://localhost:3000/facebook_auth"
		end
		@oauth = Koala::Facebook::OAuth.new(ENV['Facebook_App_ID'], ENV['Facebook_Secret'], callback_url)
	end

end