class Inventory < ActiveRecord::Base
	belongs_to :signup
  has_many :transactions, :through => :bookings

	validates :signup_id, presence: true
  validate :custom_validation

  def custom_validation
    errors[:base] << "Please select at least one item" if self.itemlist_id.blank? 
  end

  def save_spreadsheet
      connection = GoogleDrive.login(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
      ss = connection.spreadsheet_by_title('Inventory v2') if Rails.env == "production"
      ss = connection.spreadsheet_by_title('Inventory old') if Rails.env != "production"
      ws = ss.worksheets[0]
      row = 1 + ws.num_rows #finds last row
      ws[row, 1] = self.signup.email
      ws[row, 2] = self.item_name
      ws[row, 3] = self.signup.streetone + " & " + self.signup.streettwo 
      ws[row, 4] = self.created_at
      ws.save
  end 

		
end
