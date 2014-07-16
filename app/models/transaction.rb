class Transaction < ActiveRecord::Base
	before_validation :set_default_status1
	belongs_to :request
	accepts_nested_attributes_for :request

	validates :request_id, presence: true
	validates :status1, presence: true
	validate :custom_validation

	def custom_validation
	    errors[:base] << "Please select at least one item" if self.itemlist_id.blank? 
	end

	def save_spreadsheet
	    connection = GoogleDrive.login(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
	    ss = connection.spreadsheet_by_title('Request spreadsheet v2') if Rails.env == "production"
	    ss = connection.spreadsheet_by_title('Request spreadsheet') if Rails.env != "production"
	    ws = ss.worksheets[0]
	    row = 1 + ws.num_rows #finds last row
	    ws[row, 1] = self.request.edit_id
	    ws[row, 2] = self.created_at
	    ws[row, 3] = self.name
	    ws[row, 4] = self.request.detail
	    ws[row, 5] = self.request.pickupdate
	    ws[row, 6] = self.request.returndate
	    #ws[row, 6] = self.name
	    ws[row, 7] = self.request.signup.email
	    #ws[row, 8] = self.paydeliver
	    ws[row, 8] = self.request.signup.streetone + " & " + self.request.signup.streettwo
	    #ws[row, 10] = self.timedeliver
	    #ws[row, 11] = self.instrucdeliver
	    ws[row, 9] = self.request.signup.heard
	    if (self.request.pickupdate - self.created_at) < 0
	      ws[row, 10] = 0  
	    else
	      ws[row, 10] = ((self.request.pickupdate - self.created_at)/60/60/24).round(1)
	    end
	    ws[row, 11] = ((self.request.returndate - self.request.pickupdate)/60/60/24).round(1)
	    ws.save
  	end 

  	private

  	def set_default_status1
      self.status1 = Status.find_by_name("Searching").id
    end
end
