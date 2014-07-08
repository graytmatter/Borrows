class Itemlist < ActiveRecord::Base
  belongs_to :categorylist
  validate :custom_validation
  validates :name, presence: true

  def custom_validation
    errors[:base] << "Please select either request or inventory list" unless (self.request_list == true) || (self.inventory_list == true) 
    errors[:base] << "Please select a category" if self.categorylist_id.blank?
  end

end
