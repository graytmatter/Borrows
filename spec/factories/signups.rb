require 'faker'

FactoryGirl.define do
	factory :signup_email, class: Signup do 
		email { Faker::Internet.email }
		# heard { "random" }
		# streetone { "Post" }
		# streettwo { "Taylor" }
		# zipcode { "94109" }
		# tos { true }
	end

	factory :signup_full, class: Signup do 
		email { Faker::Internet.email }
		heard { "random" }
		streetone { "Post" }
		streettwo { "Taylor" }
		zipcode { 94109 }
		tos { true }
	end

	factory :invalid_signup_email, class: Signup do 
		email { nil }
	end

	factory :invalid_signup_full, class: Signup do
		email { Faker::Internet.email }
		heard { "" }
		streetone { "" }
		streettwo { "" }
		zipcode { nil }
		tos { nil }
	end

	factory :repeat_signup, class: Signup do
		email { "jdong8@gmail.com" }
	end
end
	