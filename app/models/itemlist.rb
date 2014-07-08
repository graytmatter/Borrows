class Itemlist < ActiveRecord::Base
  validate :custom_validation
  validates :name, presence: true
  validates :category, presence: true

  def custom_validation
    errors[:base] << "Please select one list category" unless (self.request_list == true) || (self.inventory_list == true) 
  end

end
