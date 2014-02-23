require 'spec_helper'

describe "entry_codes/index" do
  before(:each) do
    assign(:entry_codes, [
      stub_model(EntryCode,
        :code => "Code",
        :active => false
      ),
      stub_model(EntryCode,
        :code => "Code",
        :active => false
      )
    ])
  end

  it "renders a list of entry_codes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
