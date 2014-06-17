# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    request_id 1
    item_id 1
    name "MyString"
    startdate "2014-06-16 17:56:50"
    enddate "2014-06-16 17:56:50"
    status 1
  end
end
