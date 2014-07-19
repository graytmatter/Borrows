class RequestMailer < ActionMailer::Base

  # Passed params need to be re-assigned to variables so that they can be read in the mailer views
    
  def not_found(borrow_id, requestrecord)
    @requestrecord = requestrecord
    @item = Itemlist.find_by_id(Borrow.find_by_id(borrow_id).itemlist_id).name
    mail(to: @requestrecord.signup.email, from: ENV['owner'], bcc: ENV['owner'], :subject => "[Project Borrow]: Could not find #{@quantity} of #{@item} for #{@requestrecord.signup.email}") 
  end

  def connect_email(borrow_id, inventory_id, requestrecord)
    @requestrecord = requestrecord
    @item = Itemlist.find_by_id(Borrow.find_by_id(borrow_id).itemlist_id).name
    @lender_email = Inventory.find_by_id(inventory_id).signup.email
    mail(to: @requestrecord.signup.email, cc: @lender_email, from: ENV['owner'], :subject => "[Project Borrow]: #{@item} exchange!") 
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
