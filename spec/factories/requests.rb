require 'faker'

FactoryGirl.define do
	factory :request do |f|
		f.name { Faker::Name.name }
		f.email { Faker::Internet.email }
		f.item { "random item" }
		f.detail { "random text" }
		f.rentdate { "random text" }
		f.paydeliver { true }
	end
end
	
FactoryGirl.define do
	factory :invalid_request, parent: :request do |f|
		f.name { nil }
	end
end
	