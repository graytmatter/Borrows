class InviteeMailer < ActionMailer::Base

  def invitation_email(invitee_id)
    @invitee = Invitee.find_by_id(invitee_id)
    mail(to: @invitee.email, from: ENV['owner'], :subject => "A friend thinks you'd be a great fit for Project Borrow!")
		@invitee.update_attributes(sent: true)	
  end
  
end
