class RequestMailer < ActionMailer::Base

  def confirmation_email(request)
    @requestrecord = request
    mail(to: ENV['owner'], from: @requestrecord.email, :subject => "New item request #{@requestrecord.edit_id}") 
  end

  def update_email(request)
    @requestrecord = request
    mail(to: ENV['owner'], from: @requestrecord.email, :subject => "Update on item request #{@requestrecord.edit_id}")
  end


end
