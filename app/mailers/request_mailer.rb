class RequestMailer < ActionMailer::Base

  def not_found_email(requestrecord, matched_inventory_id, itemlist_id, quantity)
    # Passed params need to be re-assigned to variables so that they can be read in the mailer views
    @requestrecord = requestrecord
    @found_quantity = matched_inventory_id.count
    @item = Itemlist.find_by_id(itemlist_id).name
    @quantity = quantity.to_i
    mail(to: ENV['owner'], from: @requestrecord.signup.email, :subject => "ALERT: Could not find #{@quantity} of #{@item} for #{@requestrecord.signup.email}") 
  end

  def found_email(requestrecord, lender_array, itemlist_id, quantity)
    @requestrecord = requestrecord
    lender_array = lender_array
    @item = Itemlist.find_by_id(itemlist_id).name
    @quantity = quantity.to_i
    mail(to: ENV['owner'], from: ENV['owner'], bcc: lender_array, :subject => "Lend your #{@item.downcase}?") 
  end

  def same_as_today(requestrecord)
    @requestrecord = requestrecord
    @requestlist = Hash.new
    @requestrecord.borrows.each do |b|
      @requestlist["#{Itemlist.find_by_id(b.id).name}"] = "#{Signup.where(id: Borrow.find_by_id(75).inventories.pluck("signup_id")).pluck("email")}"
    end
    mail(to: ENV['owner'], from: @requestrecord.signup.email, :subject => "ALERT: Same day request") 
  end
end
