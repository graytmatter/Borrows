class Request < ActiveRecord::Base
  before_create :create_edit_id
  
  serialize :items
  validate :must_have_one_item

  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validate :borrow_date
  validates :addysdeliver, presence: true
  
=begin
  validates :name, presence: true, length: { maximum: 50 }, format: { with: /\s/ }
  validates :paydeliver, :inclusion => {:in => [true, false]}
  validates :addysdeliver, presence: true, :if => :paydeliver?
  validates :timedeliver, presence: true, :if => :paydeliver?
=end

  def must_have_one_item
    errors.add(:items, 'You must select at least one item') unless self.items.detect { |i| i != "0" } 
  end

  def borrow_date
    errors.add(:borrow_date, 'End date must be after start date') if self.startdate > self.enddate
  end

  def save_spreadsheet
    connection = GoogleDrive.login(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
    ss = connection.spreadsheet_by_title('Request spreadsheet v2') if Rails.env == "production"
    ss = connection.spreadsheet_by_title('Request spreadsheet') if Rails.env == "development"
    ws = ss.worksheets[0]
    row = 1 + ws.num_rows #finds last row
    ws[row, 1] = self.edit_id
    ws[row, 2] = self.created_at
    ws[row, 3] = self.items
    ws[row, 4] = self.detail
    ws[row, 5] = self.startdate
    ws[row, 6] = self.enddate
    #ws[row, 6] = self.name
    ws[row, 7] = self.email
    #ws[row, 8] = self.paydeliver
    ws[row, 8] = self.addysdeliver
    #ws[row, 10] = self.timedeliver
    #ws[row, 11] = self.instrucdeliver
    ws[row, 9] = self.heard
    if (self.startdate - self.created_at) < 0
      ws[row, 10] = 0  
    else
      ws[row, 10] = ((self.startdate - self.created_at)/60/60/24).round(1)
    end
    ws[row, 11] = ((self.enddate - self.startdate)/60/60/24).round(1)
    ws.save
  end 

=begin
  def update_spreadsheet
    connection = GoogleDrive.login(ENV['g_username'], ENV['g_password'])
    ss = connection.spreadsheet_by_title(ENV['spreadsheet_title'])
    ws = ss.worksheets[0]
    row = get_cell(self.edit_id)
    ws[row, 2] = Time.new
    ws[row, 3] = self.items
    ws[row, 4] = self.detail
    ws[row, 5] = self.email
    ws[row, 6] = self.name
    ws.save
  end
=end

=begin #supports entry_codes
  def to_param
    self.edit_id
  end
=end

  private

    def Request.new_edit_id
      SecureRandom.urlsafe_base64
    end

    def create_edit_id
      self.edit_id = Request.new_edit_id
    end
end
