FactoryGirl.define do
	factory :request do |f|
		f.pickupdate { DateTime.now  }
		f.returndate { DateTime.now + rand(10) }
		f.signup_id { rand(0..1000000000) }
		f.detail { "random" }
	end
end
	
FactoryGirl.define do
	factory :invalid_request, parent: :request do |f|
		f.email { nil }
	end
end
	