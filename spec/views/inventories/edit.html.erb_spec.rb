require 'spec_helper'

describe "inventories/edit" do
  before(:each) do
    @inventory = assign(:inventory, stub_model(Inventory,
      :item_name => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit inventory form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", inventory_path(@inventory), "post" do
      assert_select "input#inventory_item_name[name=?]", "inventory[item_name]"
      assert_select "input#inventory_user_id[name=?]", "inventory[user_id]"
    end
  end
end
