class Request < ActiveRecord::Base
  include Dateoverlap
  
  before_create :create_edit_id
  
  belongs_to :signup
  has_many :borrows, dependent: :destroy

  # validates :signup_id, presence: true
  # validate :custom_validation

  def custom_validation
    errors[:base] << "Please enter both a pick up date and a return date" if self.pickupdate.blank? || self.returndate.blank?
    if self.pickupdate.present? && self.returndate.present?
      errors[:base] << "Please enter a pick up date and a return date on or after today" if (self.pickupdate.to_date < Date.today) || (self.returndate.to_date < Date.today)
      errors[:base] << "Please enter a return date that is on or after the pick up date" if self.pickupdate > self.returndate
      errors[:base] << "Please submit requests with a maximum 2-week duration, we don't have enough lenders at this time to offer long term borrows" if (self.returndate.to_date - self.pickupdate.to_date).to_i > 14
    end
  end

# HAVE TO GO IN THIS ORDER! Also before doing anything, have to make sure Itemlists/ Categorylists  are fully updated with next rev 

# FIRST 
# Request.where("heard <> ''").each { |request| request.signup.update_attributes(heard: request.heard) }


# Check
# firsttest = Array.new
# Request.where("heard <> ''").each do |r|
#   if r.heard == r.signup.heard
#     firsttest << "OK"
#     else
#       firsttest << "ERROR at #{r.id}"
#     end
#   end
# firsttest

# SECOND
# ActiveRecord::Base.record_timestamps = false
# Request.where("items <> '' ").each do |r|
#   r.items.each do |i|
#     borrow.create(request_id: r.id, itemlist_id: Itemlist.find_by_name(i).id, created_at: r.created_at)
#   end
# end
# ActiveRecord::Base.record_timestamps = true

# Check
# secondtest = []
# Request.where("items <> '' ").each do |r|
#   if r.items.count == r.borrows.count
#     secondtest << "OK"
#   else 
#     secondtest << "ERROR at #{r.id}"
#   end
# end
# secondtest

# THIRD DONE
# Request.where("signup_id is null").each { |r| r.update_attributes(signup_id: Signup.where(email: r.email).first.id) }

# Check DONE
# thirdtest = Array.new
# Request.where("signup_id is not null").where("email is not null").each do |r|
#   if r.email == r.signup.email
#     thirdtest << "OK"
#     else
#       thirdtest << "ERROR at #{r.id}"
#     end
#   end
# thirdtest

# FOURTH
# borrow.where("itemlist_id is null").each do |t| 
#   if Itemlist.find_by_name(t.name)
#     t.update_attributes(itemlist_id: Itemlist.find_by_name(t.name).id)
#   end
# end
# then manually update the rest

# Check 
# fourthtest = []
# borrow.where("itemlist_id is not null").each do |t|
#   if t.name == Itemlist.find_by_id(t.itemlist_id).name
#     fourthtest << "OK"
#   else
#     fourthtest << "Error at #{t.id}"
#   end
# end

# fourthtest

# FIFTH DONE
# Signup.all.each { |s| s.update_attributes(email: s.email.downcase, zipcode: s.zipcode.to_i) }

# FINAL CHECKS
# Check that all Request does belong to a Signup (i.e., signup.email exists) DONE!
# Check that all Signups have lower case emails

# Check that all borrows belong to a Request
# Check that all borrows have an Itemlist
# Check that all borrows have two statuses
# Check that all Inventories have an Itemlist ID

# Check that all Request have a signup_id field
# Check that all borrows has a itemlist_id field and a request_id field

# DELETE EXTRANEOUS COLUMNS YAY!""

# REALITY:

# 1)  Signup.all.each do |s|
#    s.update_attributes(email: s.email.downcase) 
#  end
# 2)  Signup.where("zipcode IS NOT NULL").each { |s| s.update_attributes(zipcode: s.zipcode.to_i) }
# 3)  Request.where("email IS NOT NULL").each { |r| r.update_attributes(email: r.email.downcase) }
# 4)  ActiveRecord::Base.record_timestamps = false

# Request.where("email is not null").select { |r| Signup.where(email: r.email).present? == false }.each { |r| Signup.create(email: r.email, heard: r.heard) } 
# ActiveRecord::Base.record_timestamps = true

# 5) Request.where("email is not null").select { |r| Signup.where(email: r.email).present? == true }.each { |r| r.update_attributes(signup_id: Signup.where(email: r.email).first.id) } 

# 6) Request.where("signup_id is null").select { |r| Signup.where(email: r.email).present? == true }.each do |r| 
#   r.update_attributes(signup_id: Signup.where(email: r.email).first.id) 
#   end

# CHECKED by: 
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
