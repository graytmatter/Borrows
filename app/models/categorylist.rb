class Categorylist < ActiveRecord::Base
	has_many :itemlists

	validates :name, presence: true
end
