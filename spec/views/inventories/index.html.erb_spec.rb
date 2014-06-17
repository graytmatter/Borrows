require 'spec_helper'

describe "inventories/index" do
  before(:each) do
    assign(:inventories, [
      stub_model(Inventory,
        :item_name => "Item Name",
        :user_id => 1
      ),
      stub_model(Inventory,
        :item_name => "Item Name",
        :user_id => 1
      )
    ])
  end

  it "renders a list of inventories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Item Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
