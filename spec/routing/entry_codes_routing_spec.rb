require "spec_helper"

describe EntryCodesController do
  describe "routing" do

    it "routes to #index" do
      get("/entry_codes").should route_to("entry_codes#index")
    end

    it "routes to #new" do
      get("/entry_codes/new").should route_to("entry_codes#new")
    end

    it "routes to #show" do
      get("/entry_codes/1").should route_to("entry_codes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/entry_codes/1/edit").should route_to("entry_codes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/entry_codes").should route_to("entry_codes#create")
    end

    it "routes to #update" do
      put("/entry_codes/1").should route_to("entry_codes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/entry_codes/1").should route_to("entry_codes#destroy", :id => "1")
    end

  end
end
