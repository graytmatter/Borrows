class Inventory < ActiveRecord::Base
	belongs_to :signup

  #validate :must_have_one_item
	validates :signup_id, presence: true

  # def must_have_one_item
  #   errors.add(:item_name, 'You must select at least one item') unless Signup.find_by_email(session[:signup_email]).inventories.exists? 
  # end

  def save_spreadsheet
    connection = GoogleDrive.login(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
    ss = connection.spreadsheet_by_title('Inventory v2') if Rails.env == "production"
    ss = connection.spreadsheet_by_title('Inventory old') if Rails.env != "production"
    ws = ss.worksheets[0]
    row = 1 + ws.num_rows #finds last row
    ws[row, 1] = self.signup.email
    ws[row, 2] = self.item_name
    ws[row, 3] = self.signup.streetone
    ws[row, 4] = self.signup.streettwo
    #ws[row, 5] = self.item_info
  end
		
end
