# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitee do
    email "MyString"
    sent false
    referer ""
  end
end
