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
			if Signup.exists?(email:@signup.email) == false
				@signup.save_subscrip
			else
			    session[:signup_email] = @signup.email
			    redirect_to new_request_path
			end
		else
			render new_signup_path
		end

	end

private

def signup_params 
	params.require(:signup).permit(:email, :name, :heard) 
end

end