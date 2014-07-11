class Status < ActiveRecord::Base
	belongs_to :statuscategory

	validate :custom_validation
	validates :name, presence: true

  def custom_validation
    errors[:base] << "Please select a status category" if self.statuscategory_id.blank?
  end
end
