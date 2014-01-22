require 'faker'

FactoryGirl.define do
	factory :signup do |f|
		f.name { Faker::Name.name }
		f.email { Faker::Internet.email }
		f.heard { "random text" }
	end
end
	