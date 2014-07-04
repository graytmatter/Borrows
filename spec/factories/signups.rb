require 'faker'

FactoryGirl.define do
	factory :signup do |f|
		f.email { Faker::Internet.email }
		f.heard { "random" }
		f.streetone { "Post" }
		f.streettwo { "Taylor" }
		f.zipcode { "94109" }
		f.tos { true }
	end
end

FactoryGirl.define do
	factory :initial_signup, parent: :signup do |f|
		f.email { Faker::Internet.email }
	end
end
	
FactoryGirl.define do
	factory :invalid_initial_signup, parent: :signup do |f|
		f.email { nil }
	end
end

FactoryGirl.define do
	factory :invalid_update_signup, parent: :signup do |f|
		f.email { Faker::Internet.email }
		f.tos { true }
	end
end

FactoryGirl.define do
	factory :repeat_signup, parent: :signup do |f|
		f.email { "jdong8@gmail.com" }
	end
end
	