# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :agreement do
    user_id 1
    date "2014-08-05"
    isAgree false
  end
end
