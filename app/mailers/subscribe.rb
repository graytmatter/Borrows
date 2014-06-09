class Subscribe < ActionMailer::Base
  def notification_email(signup)
    @signup = signup
    mail(to: @signup.email, from: ENV['owner'], :subject => "Thanks for visiting Project Borrow!") 
  end
end