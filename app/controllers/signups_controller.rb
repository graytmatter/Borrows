class SignupsController < ApplicationController

	def new
		@signup = Signup.new
		images
		howto
	end

	def create
		@signup = Signup.new(signup_params)
		images
		howto
		if @signup.save
			@signup.save_subscrip
			redirect_to new_request_path
		else
			render new_signup_path
		end

	end

private

def signup_params 
	params.require(:signup).permit(:email, :name, :heard) 
end

end