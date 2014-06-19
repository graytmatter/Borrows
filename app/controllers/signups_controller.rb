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

		if Signup.exists?(email:@signup.email)
			session[:signup_email] = @signup.email
			redirect_button
		else
			if @signup.save
				#@signup.save_subscrip
				Subscribe.notification_email(@signup).deliver
				session[:signup_email] = @signup.email
				redirect_button
			else
				render new_signup_path
			end
		end

	end

	def redirect_button
		if params[:borrow] 
			redirect_to new_request_path
		else
			redirect_to new_inventory_path
		end
	end

private

def signup_params 
	params.require(:signup).permit(:email, :name, :heard) 
end

end