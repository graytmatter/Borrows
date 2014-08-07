class Agreement < ActiveRecord::Base
  belongs_to :signup
  validates  :signup_id, presence: true
end
