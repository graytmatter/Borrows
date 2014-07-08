# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :itemlist, :class => 'Itemlists' do
    name "MyString"
    category "MyString"
    request_list false
    inventory_list false
  end
end
