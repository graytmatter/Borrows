class SignupsController < ApplicationController

	def new
		@signup = Signup.new
	end

	def create
		@signup = Signup.new
		email = signup_params["email"]

		if Signup.where(email: email.downcase).exists?
			session[:signup_email] = email.downcase
			redirect_to action: 'edit'
		else
			@signup = Signup.create(signup_params)
			if @signup.save
				if Rails.env == "test"
					SignupMailer.notification_email(@signup).deliver if Rails.env != "development"
					@signup.save_subscrip 
				else
					Subscribe.new.async.perform(@signup)
					Mailing.new.async.perform(@signup)
				end
				session[:signup_email] = @signup.email
				redirect_to action: 'edit'
			else
				render new_signup_path
			end
		end

	end

	def edit
		if Rails.env == "test"
			@signup_parent = Signup.find_by_email(session[:signup_email])
		else
			if session[:signup_email].nil?
		      flash[:danger] = "Please enter your email to get started"
		      redirect_to root_path
		    else
		      @signup_parent = Signup.find_by_email(session[:signup_email])
		    end
		end
	end

	def update
		@signup_parent = Signup.find_by_email(session[:signup_email])
		if @signup_parent.update_attributes(signup_params)
			redirect_button
		else
			render "edit"
		end	
	end
	
	def redirect_button
		if params[:borrow] 
			redirect_to new_request_path
		else
			if @signup_parent.inventories.count > 0
				redirect_to manage_inventory_path
			else
				redirect_to new_inventory_path
			end
		end
	end

private

def signup_params 
	params.require(:signup).permit(:tos, :email, :streetone, :streettwo, :zipcode, :heard) 
end

end