class Request < ActiveRecord::Base
  before_create :create_edit_id
  
  belongs_to :signup
  has_many :transactions, dependent: :destroy

  validates :signup_id, presence: true
  validate :custom_validation

  def custom_validation
    errors[:base] << "Please enter a return date that is on or after the pick up date" if self.pickupdate > self.returndate
    errors[:base] << "Please enter both a pick up date and a return date" if self.pickupdate.blank? || self.returndate.blank?
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
