require 'faker'

FactoryGirl.define do
	factory :signup do |f|
		f.email { Faker::Internet.email }
	end
end
	
FactoryGirl.define do
	factory :invalid_signup, parent: :signup do |f|
		f.email { nil }
	end
end

FactoryGirl.define do
	factory :repeat_signup, parent: :signup do |f|
		f.email { "jdong8@gmail.com" }
	end
end
	