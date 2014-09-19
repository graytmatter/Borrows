class InviteesController < ApplicationController

	def create
		invitee_params
		emails = params[:emails].split(',')
		referer = params[:referer]
    Referral.new.async.perform(emails, referer)
    flash[:refer] = true
    redirect_to root_path
	end

private

def invitee_params 
	params.permit(:referer, :emails) 
end


end