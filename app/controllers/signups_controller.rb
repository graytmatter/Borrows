class SignupsController < ApplicationController

	def new
		@signup = Signup.new
		@agreement = @signup.agreements.new
	end

	def create
		@signup = Signup.new
		email = signup_params["email"]
		@agreement = @signup.agreements.new

