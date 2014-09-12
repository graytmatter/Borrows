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
			@signup = Signup.new(signup_params)
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

	def create_facebook
		# test to see if scopes are truly different, no difference at least with my account, might need to go live first
		# add testing somehow
		auth_hash = env["omniauth.auth"]
		puts env["omniauth.auth"]
		if Signup.find_by(facebook_id: auth_hash.uid.to_i).present?
        flash[:info] = "You've already signed up with us, thanks!"
    else
        Signup.create(facebook_id: auth_hash.uid.to_i, email: auth_hash.info.email.downcase, name: auth_hash.info.name, image_url: auth_hash.info.image) 
        flash[:success] = "Thanks for signing up!"
        # user = Signup.from_omniauth(env["omniauth.auth"])
    end
		redirect_to root_url
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
			if Geography.find_by_zipcode(@signup_parent.zipcode).present?
				redirect_button
			else
				flash[:info] = "We're building one community at a time and right now we are not in your area... yet. But now that we have your information, we'll let you know as soon as we get there! In the meantime please spread the word about Project Borrow. The faster we get other folks near you, the quicker we'll be able to expand our service!"
				redirect_to root_path
			end
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