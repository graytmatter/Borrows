class Request < ActiveRecord::Base
  include Dateoverlap
  
  before_create :create_edit_id
  
  belongs_to :signup
  has_many :borrows, dependent: :destroy

  validates :signup_id, presence: true
  validate :custom_validation

  def custom_validation
    errors[:base] << "Please enter both a pick up date and a return date" if self.pickupdate.blank? || self.returndate.blank?
    if self.pickupdate.present? && self.returndate.present?
      errors[:base] << "Please enter a pick up date and a return date on or after today" if (self.pickupdate.to_date < Date.today) || (self.returndate.to_date < Date.today)
      errors[:base] << "Please enter a return date that is on or after the pick up date" if self.pickupdate > self.returndate
      errors[:base] << "Please submit requests with a maximum 2-week duration, we don't have enough lenders at this time to offer long term borrows" if (self.returndate.to_date - self.pickupdate.to_date).to_i > 14
    end
  end

# need a lot of manual adding, roughly 100 requests may only have 1 borrow when they should have several

# FOURTH
# Borrow.where("itemlist_id is null").each do |t| 
#   if Itemlist.find_by_name(t.name)
#     t.update_attributes(itemlist_id: Itemlist.find_by_name(t.name).id)
#   end
# end
# then manually update the rest

# Check 
# fourthtest = []
# Borrow.where("itemlist_id is not null").each do |t|
#   if t.name == Itemlist.find_by_id(t.itemlist_id).name
#     fourthtest << "OK"
#   else
#     fourthtest << "Error at #{t.id}"
#   end
# end

# fourthtest


# Inventory.where("itemlist_id is null").each do |i|
#   if Itemlist.find_by_name(i.item_name).present?
#     i.update_attributes(itemlist_id: Itemlist.find_by_name(i.item_name).id)
#   end
# end

# FINAL CHECKS

# Check that all borrows belong to a Request
# Check that all borrows have an Itemlist
# Check that all borrows have two statuses
# Check that all Inventories have an Itemlist ID

# Check that all borrows has a itemlist_id field and a request_id field

# DELETE EXTRANEOUS COLUMNS YAY!""

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
