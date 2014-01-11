class Request < ActiveRecord::Base
  before_create :create_edit_id


  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :item, presence: true
  validates :detail, presence: true
  validates :name, presence: true, length: { maximum: 50 }


  private

    def Request.new_edit_id
      SecureRandom.urlsafe_base64
    end

    def create_edit_id
      self.edit_id = Request.new_edit_id
    end
end
