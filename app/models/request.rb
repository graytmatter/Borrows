class Request < ActiveRecord::Base
  before_create :create_edit_id
  
  belongs_to :signup
  has_many :transactions, dependent: :destroy

  validates :signup_id, presence: true
  validate :custom_validation

  def custom_validation
    errors[:base] << "Please enter both a pick up date and a return date" if self.pickupdate.blank? || self.returndate.blank?
    if self.pickupdate.present? && self.returndate.present?
      errors[:base] << "Please enter a return date that is on or after the pick up date" if self.pickupdate > self.returndate
    end
  end

# HAVE TO GO IN THIS ORDER! Also before doing anything, have to make sure Itemlists/ Categorylists  are fully updated with next rev 

# FIRST
# Request.where("heard <> ''").each { |request| puts request.signup.update_attributes(heard: request.heard) }

# Check
# firsttest = Array.new
# Request.where("heard <> ''").each do |r|
#   if r.heard == r.signup.heard
#     arraytest << "OK"
#     else
#       arraytest << "ERROR at #{r.id}"
#     end
#   end
# firsttest

# SECOND
# ActiveRecord::Base.record_timestamps = false
# Request.where("items <> '' ").each do |r|
#   r.items.each do |i|
#     Transaction.create(request_id: r.id, itemlist_id: Itemlist.find_by_name(i).id, created_at: r.created_at)
#   end
# end
# ActiveRecord::Base.record_timestamps = true

# Check
# secondtest = []
# Request.where("items <> '' ").each do |r|
#   if r.items.count == r.transactions.count
#     secondtest << "OK"
#   else 
#     secondtest << "ERROR at #{r.id}"
#   end
# end
# secondtest

# THIRD
# Request.where("signup_id is null").each { |r| r.update_attributes(signup_id: Signup.find_by_email(r.email).id) }

# Check
# thirdtest = Array.new
# Request.where("email <> ''").each do |r|
#   if r.email == r.signup.email
#     thirdtest << "OK"
#     else
#       thirdtest << "ERROR at #{r.id}"
#     end
#   end
# thirdtest

# FOURTH
# Transaction.where("itemlist_id is null").each do |t| 
#   if Itemlist.find_by_name(t.name)
#     t.update_attributes(itemlist_id: Itemlist.find_by_name(t.name).id)
#   end
# end
# then manually update the rest

# Check 
# fourthtest = []
# Transaction.where("itemlist_id is not null").each do |t|
#   if t.name == Itemlist.find_by_id(t.itemlist_id).name
#     fourthtest << "OK"
#   else
#     fourthtest << "Error at #{t.id}"
#   end
# end

# fourthtest

# FIFTH
# Signup.all.each { |s| s.update_attributes(email: s.email.downcase) }

# FINAL CHECKS
# Check that all Request does belong to a Signup (i.e., signup.email exists)
# Check that all Transactions belong to a Request
# Check that all Transactions have an Itemlist
# Check that all Transactions have two statuses
# Check that all Inventories have an Itemlist ID

# Check that all Request have a signup_id field
# Check that all Transactions has a itemlist_id field and a request_id field

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
