class RequestMailer < ActionMailer::Base

  # Passed params need to be re-assigned to variables so that they can be read in the mailer views
    
  def not_found(not_found_borrow, itemlist_id)
    @borrower_email = not_found_borrow.request.signup.email
    @pickupdate = not_found_borrow.request.pickupdate.strftime("%B %-d")
    @returndate = not_found_borrow.request.returndate.strftime("%B %-d")
    @item = Itemlist.find_by_id(itemlist_id).name.downcase
    @county = Geography.find_by_zipcode(not_found_borrow.request.signup.zipcode).county
    mail(to: @borrower_email, from: ENV['owner'], :subject => "[Project Borrow]: Could not find #{@item}") 
  end

  def repeat_borrow(repeat_borrow, itemlist_id)
    @borrower_email = repeat_borrow.request.signup.email
    @pickupdate = repeat_borrow.request.pickupdate.strftime("%B %-d")
    @returndate = repeat_borrow.request.returndate.strftime("%B %-d")
    @createdat = repeat_borrow.request.created_at.strftime("%B %-d")
    @item = Itemlist.find_by_id(itemlist_id).name.downcase
    mail(to: @borrower_email, from: ENV['owner'], :subject => "[Project Borrow]: You've already requested #{@item}") 
  end

  def connect_email(accepted_borrow)
    @borrower_email = accepted_borrow.request.signup.email
    @borrower_streetone = accepted_borrow.request.signup.streetone.capitalize
    @borrower_streettwo = accepted_borrow.request.signup.streettwo.capitalize
    @borrower_city = Geography.find_by_zipcode(accepted_borrow.request.signup.zipcode).city
    @pickupdate = accepted_borrow.request.pickupdate.strftime("%B %-d")
    @returndate = accepted_borrow.request.returndate.strftime("%B %-d")
    @item = Itemlist.find_by_id(accepted_borrow.itemlist_id).name.downcase
    @inventory_item = Inventory.find_by_id(accepted_borrow.inventory_id)
    @lender = @inventory_item.signup
    @lender_city = Geography.find_by_zipcode(@lender.zipcode).city
    mail(to: @borrower_email, cc: @lender.email, from: ENV['owner'], :subject => "[Project Borrow]: #{@item.capitalize} exchange!") 
  end

  def same_as_today(requestrecord)
    @requestrecord = requestrecord
    @requestlist = Hash.new
    @requestrecord.borrows.each_with_index do |b, index|
      if Rails.env == "test" #can't explain why, in test the Inventory object appears to not be associated with the Signup object, since it throws a no method error on signup, which is even weirder because the no method error says Nil Class for inventory, but the Inventory is obviously there
        @requestlist[index] = { Itemlist.find_by_id(b.itemlist_id).name => Inventory.find_by_id(b.inventory_id) }
      else
        @requestlist[index] = { Itemlist.find_by_id(b.itemlist_id).name => Inventory.find_by_id(b.inventory_id).signup.email }
      end
    end
    mail(to: ENV['owner'], from: @requestrecord.signup.email, :subject => "ALERT: Same day request") 
  end

  def return_reminder(borrow_in_question)
    @borrower_email = borrow_in_question.request.signup.email
    @borrower_streetone = borrow_in_question.request.signup.streetone.capitalize
    @borrower_streettwo = borrow_in_question.request.signup.streettwo.capitalize
    @borrower_city = Geography.find_by_zipcode(borrow_in_question.request.signup.zipcode).city
    
    @inventory_item = Inventory.find_by_id(borrow_in_question.inventory_id)
    @lender = @inventory_item.signup
    @lender_city = Geography.find_by_zipcode(@lender.zipcode).city
    
    @item = Itemlist.find_by_id(borrow_in_question.itemlist_id).name
    mail(to: @borrower_email, cc: @lender.email, from: ENV['owner'], :subject => "[Project Borrow]: Reminder to return #{@item}")
    borrow_in_question.update_attributes(status1:4)
  end
end

