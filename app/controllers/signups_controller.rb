class SignupsController < ApplicationController
	include Generating_oauth 

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
		# add testing somehow, manual test, need to go to another hack night to figure out automation
		# DONE modal styling
		# DONE add promotion via facebook: make delayed job, finish testing
		# DONE quick streamline of mailers
		# DONE test everything
		# DONE update TOS and PP to reflect friend focus 1 hour
		# DONE 1 hour - add admin page to check which city everyone is loggin in from and how they're connecte
		# DONE make sure GA links 1 hour initially, 2 to check later (event for warning, even for submit modal, refer friend link is tracked differently)
		# DONE finalize explainer video 3 hours
		# push then check photopile and test facebook signups 
		# email users the change

		get_oauth

		if params[:error].present?
			flash[:warning] = true
			flash[:success] = false
			redirect_to controller: "staticpages", action: "home"
		else
			access_token = @oauth.get_access_token(params[:code])
			graph = Koala::Facebook::API.new(access_token)
			permissions = graph.get_connections("me", "permissions") 
			user_friend_permission = permissions.select { |p| p["permission"] == "user_friends"}
			if user_friend_permission[0]["status"] != "granted"
				flash[:rerequest] = true
				flash[:warning] = true
				flash[:success] = false
				redirect_to controller: "staticpages", action: "home"
			else
				new_signup = graph.get_object("me")

				if Signup.find_by(facebook_id: new_signup["id"]).present?
	        # This is saying if they already used FACEBOOK to sign up, then return this message
	        flash[:success] = true
	        flash[:warning] = false
	        flash[:new_signup_fb_id] = new_signup["id"]
		    else

		    	if new_signup["location"].present? && new_signup["location"]["name"].present?
		    		location = new_signup["location"]["name"]
		    	else
		    		location = "not provided"
		    	end
		    	puts "INSPECT"
		    	puts location

	    		fb_email = new_signup["email"].present? ? new_signup["email"].downcase : "not provided"
	    	  # This is saying if they've been a previous user signed up via email, then update that old Signup record, otherwise make a new one
	  	  	signup = Signup.find_or_initialize_by(email: fb_email)
		  		signup.facebook_id = new_signup["id"]
		  		signup.name = new_signup["name"]
	        signup.image_url = "http://graph.facebook.com/#{new_signup["id"]}/picture"
	        signup.fb_location = location
	        signup.fb_access_token = access_token
					signup.save
					flash[:success] = true
					flash[:warning] = false
					flash[:new_signup_fb_id] = new_signup["id"]
		    end
				redirect_to controller: "staticpages", action: "home"
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

	def original
		change_date = Date.new(2014, 9, 18)
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