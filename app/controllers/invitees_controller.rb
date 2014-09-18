class InviteesController < ApplicationController

	def create
		emails = params[:emails].split(',')

		emails.each do |e|
			unless Invitee.where(sent: true).where(email: e.strip.downcase).present? || Signup.where(email: e.strip.downcase).present?
        @invitee = Invitee.create(referer: params[:referer], email: e.strip.downcase)
      	#add in model validation so that if the email is not valid it's not saved and nothing is sent
      end
      InviteeMailer.invitation_email(@invitee.id).deliver
    end

    redirect_to root_path
    flash[:info] = "Thanks for spreading the word!"

	end

private

def invitee_params 
	params.permit(:referer, :emails) 
end


end