class RequestMailer < ActionMailer::Base

  # Passed params need to be re-assigned to variables so that they can be read in the mailer views
    
  def not_found(not_found_borrow, itemlist_id)
    @borrower_email = not_found_borrow.request.signup.email
    @pickupdate = not_found_borrow.request.pickupdate.to_date
    @returndate = not_found_borrow.request.returndate.to_date
    @item = Itemlist.find_by_id(itemlist_id).name
    mail(to: @borrower_email, from: ENV['owner'], :subject => "[Project Borrow]: Could not find #{@item}") 
  end

  def connect_email(accepted_borrow)
    @borrower_email = accepted_borrow.request.signup.email
    @pickupdate = accepted_borrow.request.pickupdate.to_date
    @returndate = accepted_borrow.request.returndate.to_date
    @item = Itemlist.find_by_id(accepted_borrow.itemlist_id).name
    @lender_email = Inventory.find_by_id(accepted_borrow.inventory_id).signup.email
    mail(to: @borrower_email, cc: @lender_email, from: ENV['owner'], :subject => "[Project Borrow]: #{@item} exchange!") 
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
