class RequestMailer < ActionMailer::Base

  def not_found_email(requestrecord, matched_inventory, item, quantity)
    # Passed params need to be re-assigned to variables so that they can be read in the mailer views
    @requestrecord = requestrecord
    @matched_inventory = matched_inventory
    @item = Itemlist.find_by_id(item).name
    @quantity = quantity
    mail(to: ENV['owner'], from: @requestrecord.signup.email, :subject => "ALERT: Could not find #{@quantity} of #{@item} for #{@requestrecord.signup.email}") 
  end

  def found_email(requestrecord, lender_array, item, quantity)
    @requestrecord = requestrecord
    @lender_array = lender_array
    @item = Itemlist.find_by_id(item).name
    @quantity = quantity
    mail(to: ENV['owner'], from: ENV['owner'], bcc: @lender_array, :subject => "Project Borrow: Can you lend your #{@item.downcase}?") 
  end

  def same_as_today(requestrecord)
    @requestrecord = requestrecord
    mail(to: @requestrecord.signup.email, from: ENV['owner'], :subject => "Project Borrow: Please confirm your request") 
  end

  def significant_items(requestrecord)
    @requestrecord = requestrecord
    mail(to: ENV['owner'], from: @requestrecord.signup.email, :subject => "ALERT: Many items requested") 
  end
  # def update_email(request)
  #   @requestrecord = request
  #   mail(to: ENV['owner'], from: @requestrecord.email, :subject => "Update on item request #{@requestrecord.edit_id}")
  # end


end
