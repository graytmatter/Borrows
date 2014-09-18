class InviteeMailer < ActionMailer::Base

  def invitation_email(invitee_id)
    @invitee = Invitee.find_by_id(invitee_id)
    mail(to: @invitee_email, from: ENV['owner'], :subject => "Invitation to share with friends!")
    @invitee.update_attribute(sent: true)
  end
  
end
