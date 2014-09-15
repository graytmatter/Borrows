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
		# add testing somehow
		# server-side is still stuck because now I can't redirect the failures... perhaps need to find a way to use Koala entirely tomorrow, or use FB entirely and stop depending on a library
		# add promotion via facebook, share dialog is the one to use, unless koala has somehing (it does, but it's only for graph API which requiers advanced privileges), separate page, two options: share broadly or share private invitation
		# update TOS and PP to reflect friend focus 
		# add admin page to check which city everyone is loggin in from and how they're connecte

		auth_hash = env["omniauth.auth"]

		graph = Koala::Facebook::API.new(auth_hash.credentials.token)

		permissions = graph.get_connections(auth_hash.uid, "permissions") 
		user_friend_permission = permissions.select { |p| p["permission"] == "user_friends"}
		if user_friend_permission[0]["status"] != "granted"
			flash[:warning] = "Project Borrow is a sharing site between friends, so we require access to your Facebook friend information. If you have concerns about how this information will be used, please consult our Privacy Policy. You may click the invite button again to go through the Facebook sign up."
			redirect_to root_url
		else
			if Signup.find_by(facebook_id: auth_hash.uid.to_i).present?
        # This is saying if they already used FACEBOOK to sign up, then return this message
        flash[:info] = "You've already signed up with us, thanks!"
	    else
    		fb_email = auth_hash.info.email ? auth_hash.info.email.downcase : "not provided"
    	  # This is saying if they've been a previous user signed up via email, then update that old Signup record, otherwise make a new one
  	  	Signup.find_or_initialize_by(email: fb_email) do |signup|
  	  		signup.facebook_id = auth_hash.uid.to_i
  	  		signup.name = auth_hash.info.name
          signup.image_url = auth_hash.info.image
          signup.fb_location = auth_hash.info.location ? auth_hash.info.location : "not provided"
          signup.fb_access_token = auth_hash.credentials.token
					signup.save
				end
        flash[:success] = "Thanks for signing up!"
	    end
			redirect_to root_url
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

	def original
		change_date = Date.new(2014, 9, 1)
		@signup_parent = Signup.where("created_at < ?", change_date).find_by_email(original_params[:email])
		if original_params[:email].present?
			if @signup_parent.present?
				if original_params[:tos].to_i == 1
					@signup_parent.update_attributes(tos: true)
					if original_params[:commit] == "Woohoo! Ready to borrow!!"
						session[:signup_email] = original_params[:email]
						redirect_to new_request_path
					else
						session[:signup_email] = original_params[:email]
						if @signup_parent.inventories.count > 0
							redirect_to manage_inventory_path
						else
							redirect_to new_inventory_path
						end
					end
				else
					flash[:danger] = "We're sorry, please agree to the Terms of Service before continuing"
				end
			else
				flash[:danger] = "We're sorry, but we couldn't find that email, please try another one, or if you are a new user, return to the home page to request an invitation for when we launch!"
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

def original_params
	params.permit(:tos, :email, :commit)
end

end