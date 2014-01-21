class Signup < ActiveRecord::Base

	validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
    validates :name, presence: true, length: { maximum: 50 }, format: { with: /\s/ }

def save_subscrip
    connection = GoogleDrive.login(ENV['g_username'], ENV['g_password'])
    ss = connection.spreadsheet_by_title('Subscribers v1')
    ws = ss.worksheets[0]
    row = 1 + ws.num_rows 
    ws[row, 1] = Time.new 
    ws[row, 2] = self.name
    ws[row, 3] = self.email
    ws[row, 4] = self.heard
    ws.save
end

def add_subscrip
    mailchimp = Gibbon::API.new 
    result = mailchimp.lists.subscribe({ 
        :id => ENV['MAILCHIMP_LIST_ID'], 
        :email => {:email => self.email}, 
        :double_optin => false, 
        :update_existing => true, 
        :send_welcome => true 
    })
end


end
