require 'spec_helper'

describe "entry_codes/show" do
  before(:each) do
    @entry_code = assign(:entry_code, stub_model(EntryCode,
      :code => "Code",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code/)
    rendered.should match(/false/)
  end
end
