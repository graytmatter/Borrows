class SignupsController < ApplicationController

	def new
		@signup = Signup.new
	end

	def create
		@signup = Signup.new(signup_params)
		if @signup.save
			@signup.save_subscrip
			#@signup.add_subscrip
			flash[:success] = "Many thanks for your support. You'll hear from us soon!"
			render 'new'
		else
			render 'new'
		end

	end


private

def signup_params 
	params.require(:signup).permit(:email, :name, :heard) 
end

end
