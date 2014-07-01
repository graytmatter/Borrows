class InventoryMailer < ActionMailer::Base

  def upload_email(signup_parent, items_to_be_saved)
    @signup_parent = signup_parent
    @items_to_be_saved = items_to_be_saved
    mail(to: ENV['owner'], from: @signup_parent.email, :subject => "New inventory logged from #{@signup_parent.email}") 
  end

  def delete_email(signup_parent, destroyed)
    @signup_parent = signup_parent
    @destroyed = destroyed
    mail(to: ENV['owner'], from: @signup_parent.email, :subject => "Inventory removed from #{@signup_parent.email}") 
  end
end