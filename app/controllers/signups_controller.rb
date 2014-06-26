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
			redirect_to action: 'edit'
		else
			if @signup.save
				@signup.save_subscrip
				Subscribe.notification_email(@signup).deliver
				session[:signup_email] = @signup.email
				redirect_to action: 'edit'
			else
				render new_signup_path
			end
		end

	end

	def edit
		@signup = Signup.find_by_email(session[:signup_email])
	end

	def update
		@signup = Signup.find_by_email(session[:signup_email])
		if @signup.update_attributes(signup_params)
			redirect_button
		else
			render "edit"
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
	params.require(:signup).permit(:email, :streetone, :streettwo, :zipcode, :heard) 
end

end