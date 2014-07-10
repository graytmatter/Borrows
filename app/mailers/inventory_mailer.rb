class InventoryMailer < ActionMailer::Base

  def upload_email(signup_parent, items_to_be_saved)
    @signup_parent = signup_parent
    @items_to_be_saved = items_to_be_saved
    if @items_to_be_saved.count > ENV["item_alert_threshold"]
      mail(to: ENV['owner'], from: @signup_parent.email, :subject => "ALERT: significant inventory logged from #{@signup_parent.email}") 
    else
      mail(to: ENV['owner'], from: @signup_parent.email, :subject => "FYI: New inventory logged from #{@signup_parent.email}") 
    end
  end

  def delete_email(signup_parent, destroyed)
    @signup_parent = signup_parent
    @destroyed = destroyed
    mail(to: ENV['owner'], from: @signup_parent.email, :subject => "FYI: Inventory removed from #{@signup_parent.email}") 
  end
end