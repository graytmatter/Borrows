class Borrow < ActiveRecord::Base

	before_create :create_secure_id

	belongs_to :request
	accepts_nested_attributes_for :request

	validates :request_id, presence: true
	validates :status1, presence: true
	validates :multiple, presence: true
	validate :custom_validation

	def custom_validation
	    errors[:base] << "Please select at least one item" if self.itemlist_id.blank? 
	end

	private

    def create_secure_id
      self.secure_id = SecureRandom.urlsafe_base64
    end
	
end
