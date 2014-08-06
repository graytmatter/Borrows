class InventoryMailer < ActionMailer::Base

  def outstanding_request(lender_id)
    @lender_email = Signup.find_by_id(lender_id).email
    @items_outstanding = Array.new
    Inventory.where(signup_id: lender_id).select { |i| Borrow.where(inventory_id: i.id).select { |b| b.status1 == 1}.count > 0 }.each { |i| @items_outstanding << Itemlist.find_by_id(i.itemlist_id).name }
    # mail(to: @lender_email, from: ENV['owner'], :subject => "[Project Borrow]: Can someone borrow your stuff?")
    mail(to: "jdong8@gmail.com", from: ENV['owner'], :subject => "[Project Borrow]: Can someone borrow your stuff?")
    
    logger.debug "sent mail to #{@lender_email} at local time: #{Time.now.in_time_zone('Pacific Time (US & Canada)')}, UTC time: #{Time.now.getutc}"

  end
end
