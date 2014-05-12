class Subscribe < ActionMailer::Base
  def notification_email(signup)
    @signup = signup
    mail(to: @signup.email, from: ENV['owner'], bcc: ENV['owner'], :subject => "Thanks for visiting our borrowing site!") 
  end
end