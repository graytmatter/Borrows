class SignupsController < ApplicationController

	def new
		@signup = Signup.new
	end

	def create
		@signup = Signup.new(signup_params)

		if Signup.exists?(email:@signup.email.downcase)
			session[:signup_email] = @signup.email.downcase
			redirect_to action: 'edit'
		else
			if @signup.save
				@signup.save_subscrip 
				Subscribe.notification_email(@signup).deliver 
				session[:signup_email] = @signup.email.downcase
				redirect_to action: 'edit'
			else
				render new_signup_path
			end
		end

	end

	def edit
		if session[:signup_email].nil?
	      flash[:danger] = "Please enter your email to get started"
	      redirect_to root_path
	    else
	      @signup_parent = Signup.find_by_email(session[:signup_email])
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