OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do 
	  provider :facebook, ENV['Facebook_App_ID'], ENV['Facebook_Secret'],
	  scope: "user_friends, email, public_profile, user_location", display: "popup"
end