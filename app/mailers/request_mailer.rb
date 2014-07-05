class RequestMailer < ActionMailer::Base

  # def confirmation_email(request)
  #   @requestrecord = request
  #   mail(to: ENV['owner'], from: @requestrecord.signup.email, :subject => "New item request #{@requestrecord.edit_id}") 
  # end

  def not_found_email(requester, item)
    @requestrecord = requester
    @t = item
    mail(to: ENV['owner'], from: @requestrecord.signup.email, :subject => "Could not find #{@t.name} for #{@requestrecord.signup.email}") 
  end

  def found_email(lender_array, item, quantity)
    @lender_array = lender_array
    @item = item
    @quantity = quantity
    mail(to: ENV['owner'], from: ENV['owner'], bcc: @lender_array, :subject => "Project Borrow: Can you lend your #{@item.name.downcase}?") 
  end

  # def update_email(request)
  #   @requestrecord = request
  #   mail(to: ENV['owner'], from: @requestrecord.email, :subject => "Update on item request #{@requestrecord.edit_id}")
  # end


end
