# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :inventory do
    itemlist_id { rand(0..1000000000) }
    signup_id { rand(0..1000) }
    description { "random" }
  end
end
