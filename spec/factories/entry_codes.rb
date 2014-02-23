# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry_code do
    code "MyString"
    active false
  end
end
