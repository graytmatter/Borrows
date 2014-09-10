class InventoryMailer < ActionMailer::Base

  def outstanding_request(lender_id)
    @mailer = true
    @lender_email = Signup.find_by_id(lender_id).email
    @inventories = Signup.find_by_id(lender_id).inventories.where(available: true).select { |i| Borrow.where(status1: 1).where(inventory_id: i).present? }
    # @items_outstanding = Array.new
    # Inventory.where(signup_id: lender_id).select { |i| Borrow.where(inventory_id: i.id).select { |b| b.status1 == 1}.count > 0 }.each { |i| @items_outstanding << Itemlist.find_by_id(i.itemlist_id).name }
    # mail(to: @lender_email, from: ENV['owner'], :subject => "[Project Borrow]: Can someone borrow your stuff?")
    mail(to: @lender_email, from: ENV['owner'], :subject => "[Project Borrow]: Accept/ decline requests right in your email!")
    Signup.find_by_id(lender_id).update_attribute(:last_emailed_on, Date.today)
    logger.debug "sent mail to #{@lender_email} at local time: #{Time.now.in_time_zone('Pacific Time (US & Canada)')}, UTC time: #{Time.now.getutc}"

  end
end
