require 'spec_helper'

describe "EntryCodes" do
  describe "GET /entry_codes" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get entry_codes_path
      response.status.should be(200)
    end
  end
end
