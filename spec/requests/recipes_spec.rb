require "spec_helper"

describe "requests to recipes" do
  describe "GET /recipes" do
    it do
      get "/recipes.json"
      response.status.should == 200
      JSON.parse(response.body).should == []
    end
  end
end
