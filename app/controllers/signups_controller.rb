class SignupsController < ApplicationController

	def new
		@signup = Signup.new
	end

	def create
		@signup = Signup.new(signup_params)
		if @signup.save
			@signup.add_subscrip
			#flash.now[:notice] = "Many thanks for your support. You'll hear from us soon!"
			redirect_to root_path
		else
			render new_signup_path
		end

	end

	def edit
	end

	def update
	end

private

def signup_params 
	params.require(:signup).permit(:email, :name) 
end

end
