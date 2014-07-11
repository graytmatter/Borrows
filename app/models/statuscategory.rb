class Statuscategory < ActiveRecord::Base
	has_many :statuses

	validates :name, presence: true
end
