class SignupsController < ApplicationController

	def new
		@signup = Signup.new
	end

	def create
		@signup = Signup.new(signup_params)
		if @signup.save
			signup.add_subscrip
		else
			redirect_to new_signup_path
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
