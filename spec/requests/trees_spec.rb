require 'spec_helper'

describe "Trees" do
  describe "GET /trees" do
    it "displays tree list" do
    	kind = Kind.create!(:botanic_name => "A Tree")
      trees = Tree.create!(:given_name => "Dinsdale", :kind => kind.id, :location_desc => "A Location")
      get trees_path
      response.body.should include("Dinsdale")
    end
  end
end
