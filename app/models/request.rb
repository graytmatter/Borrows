class Request < ActiveRecord::Base
  include Dateoverlap
  
  before_create :create_edit_id
  
  belongs_to :signup
  has_many :borrows, dependent: :destroy

  validates :signup_id, presence: true
  validate :custom_validation, on: :create

  def custom_validation
    errors[:base] << "Please enter both a pick up date and a return date" if self.pickupdate.blank? || self.returndate.blank?
    if self.pickupdate.present? && self.returndate.present?
      errors[:base] << "Please enter a pick up date and a return date on or after today" if (self.pickupdate.to_date < Date.today) || (self.returndate.to_date < Date.today)
      errors[:base] << "Please enter a return date that is on or after the pick up date" if self.pickupdate > self.returndate
      errors[:base] << "Please submit requests with a maximum 2-week duration, we don't have enough lenders at this time to offer long term borrows" if (self.returndate.to_date - self.pickupdate.to_date).to_i > 14
    end
  end

  private

    def Request.new_edit_id
      SecureRandom.urlsafe_base64
    end

    def create_edit_id
      self.edit_id = Request.new_edit_id
    end
end
