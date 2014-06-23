class Transaction < ActiveRecord::Base

	validates :request_id, presence: true
end
