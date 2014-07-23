# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :itemlist do
    name { "random" }
    categorylist_id { rand(0..5) }
    request_list { true }
    inventory_list { false }
  end
end
