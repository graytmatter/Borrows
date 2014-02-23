require 'spec_helper'

describe "entry_codes/edit" do
  before(:each) do
    @entry_code = assign(:entry_code, stub_model(EntryCode,
      :code => "MyString",
      :active => false
    ))
  end

  it "renders the edit entry_code form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", entry_code_path(@entry_code), "post" do
      assert_select "input#entry_code_code[name=?]", "entry_code[code]"
      assert_select "input#entry_code_active[name=?]", "entry_code[active]"
    end
  end
end
