require "spec_helper"

describe WallsController do
  describe "routing" do

    it "routes to #index" do
      get("/walls").should route_to("walls#index")
    end

    it "routes to #new" do
      get("/walls/new").should route_to("walls#new")
    end

    it "routes to #show" do
      get("/walls/1").should route_to("walls#show", :id => "1")
    end

    it "routes to #edit" do
      get("/walls/1/edit").should route_to("walls#edit", :id => "1")
    end

    it "routes to #create" do
      post("/walls").should route_to("walls#create")
    end

    it "routes to #update" do
      put("/walls/1").should route_to("walls#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/walls/1").should route_to("walls#destroy", :id => "1")
    end

  end
end
