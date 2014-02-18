class RequestMailer < ActionMailer::Base
  default from: ENV['owner']

  def confirmation_email(request, url)
    @url = url
    @requestrecord = request
    mail to: @requestrecord.email, bcc: ENV['owner'], subject: "Request for #{@requestrecord.item.downcase} received! Update link inside."
  end

  def update_email(request, url)
    @url = url 
    @requestrecord = request
    mail to: ENV['owner'], subject: "Update on #{@requestrecord.name}", template_name: "confirmation_email"
  end
end
