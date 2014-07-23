class SignupMailer < ActionMailer::Base
  def notification_email(new_user)
    @new_user = new_user
    mail(to: @new_user.email, from: ENV['owner'], :subject => "Thanks for visiting Project Borrow!") 
  end
end