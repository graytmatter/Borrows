# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :inventory do
    item_name { "item" }
    signup_id { rand(0..1000000000) }
    description { "random" }
  end
end
