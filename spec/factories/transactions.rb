# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    request_id { rand(0..1000000000) }
    item_id { rand(0..1000000000) }
    name { "item name" }
    status { rand(0..5) } 
  end
end
