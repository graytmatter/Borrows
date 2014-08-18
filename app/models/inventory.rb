class Inventory < ActiveRecord::Base
  include Dateoverlap
  
	belongs_to :signup
	validates :signup_id, presence: true
  validate :custom_validation

  def custom_validation
    errors[:base] << "Please select at least one item" if self.itemlist_id.blank? 
  end
	
end
