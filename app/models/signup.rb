class Signup < ActiveRecord::Base
    has_many :inventories, dependent: :destroy
    has_many :requests
    
    validate :create_validation, on: :create
    validate :update_validation, on: :update

    def create_validation
        errors[:base] << "Please enter a valid email address to continue" if self.email.blank? || ( /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i =~ self.email) == nil 
    end

    def update_validation
        errors[:base] << "Please enter two street names" if self.streetone.blank? || self.streettwo.blank?
        errors[:base] << "Please enter a valid 5-digit zipcode" if self.zipcode.blank? || ( self.zipcode.length != 5 )
        errors[:base] << "Please agree to the terms of service before continuing" unless self.tos == true
    end

def save_subscrip
    connection = GoogleDrive.login(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
    if Rails.env == "production"
        ss = connection.spreadsheet_by_title('Visitor spreadsheet') 
    else
        ss = connection.spreadsheet_by_title('Visitor spreadsheet old')
    end
    ws = ss.worksheets[0]
    row = 1 + ws.num_rows 
    ws[row, 1] = Time.new 
    ws[row, 2] = self.name
    ws[row, 3] = self.email
    ws[row, 4] = self.heard
    ws.save
end

=begin
def add_subscrip
    mailchimp = Gibbon::API.new 
    result = mailchimp.lists.subscribe({ 
        :id => ENV['MAILCHIMP_LIST_ID'], 
        :email => {:email => self.email}, 
        :double_optin => false, 
        :update_existing => true, 
        :send_welcome => true 
    })
    Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
end
=end


end
