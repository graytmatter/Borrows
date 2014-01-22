require 'faker'

FactoryGirl.define do
	factory :signup do |f|
		f.name { Faker::Name.name }
		f.email { Faker::Internet.email }
		f.heard { "random text" }
	end
end
	
FactoryGirl.define do
	factory :invalid_signup, parent: :signup do |f|
		f.name { nil }
	end
end
	