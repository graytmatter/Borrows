class RequestMailer < ActionMailer::Base
  default from: ENV['owner']

  def confirmation_email(request, url)
    @url = url
    @request = request
    mail to: @request.email, bcc: ENV['owner'], subject: "Request for #{@request.item.downcase} received! Update link inside."
  end

  def update_email(request, url)
    @url = url 
    @request = request
    mail to: ENV['owner'], subject: "Update on #{@request.name}", template_name: "confirmation_email"
  end
end
