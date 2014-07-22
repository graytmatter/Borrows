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
    @requestrecord.borrows.each_with_index do |b, index|
      if Rails.env == "test" #can't explain why, in test the Inventory object appears to not be associated with the Signup object, since it throws a no method error on signup, which is even weirder because the no method error says Nil Class for inventory, but the Inventory is obviously there
        @requestlist["#{index}"] = {"#{Itemlist.find_by_id(b.itemlist_id).name}" => "#{Inventory.find_by_id(b.inventory_id)}"}
      else
        @requestlist["#{index}"] = {"#{Itemlist.find_by_id(b.itemlist_id).name}" => "#{Inventory.find_by_id(b.inventory_id).signup.email}"}
      end
    end
    mail(to: ENV['owner'], from: @requestrecord.signup.email, :subject => "ALERT: Same day request") 
  end
end
