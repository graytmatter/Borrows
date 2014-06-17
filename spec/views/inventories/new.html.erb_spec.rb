require 'spec_helper'

describe "inventories/new" do
  before(:each) do
    assign(:inventory, stub_model(Inventory,
      :item_name => "MyString",
      :user_id => 1
    ).as_new_record)
  end

  it "renders new inventory form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", inventories_path, "post" do
      assert_select "input#inventory_item_name[name=?]", "inventory[item_name]"
      assert_select "input#inventory_user_id[name=?]", "inventory[user_id]"
    end
  end
end
