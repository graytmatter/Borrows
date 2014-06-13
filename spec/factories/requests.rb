require 'faker'

FactoryGirl.define do
	factory :request do |f|
		f.email { Faker::Internet.email }
		f.items { ["random item"] }
		f.addysdeliver { "random text" }
		f.startdate { DateTime.now  }
		f.enddate { (rand(10)+1).from_now }
	end
end
	
FactoryGirl.define do
	factory :invalid_request, parent: :request do |f|
		f.email { nil }
	end
end
	