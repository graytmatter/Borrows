# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :borrow do
    request_id { rand(0..1000000000) }
    itemlist_id { rand(0..1000000000) }
    status1 { rand(0..5) }
    multiple { rand(0..5) } 
  end
end
