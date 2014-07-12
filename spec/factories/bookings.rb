# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booking, :class => 'Bookings' do
    inventory_id "MyString"
    integer "MyString"
    transaction_id "MyString"
    integer "MyString"
  end
end
