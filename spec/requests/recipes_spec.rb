require "spec_helper"

describe "requests to recipes" do
  let(:recipe) do
    Recipe.create(:title => "title")
  end

  describe "GET /recipes" do
    it do
      get "/recipes.json"
      response.status.should == 200
      response.body.should be_json([])
    end
  end

  describe "GET /recipes/:id" do
    it do
      get "/recipes/#{recipe.id}.json"
      response.status.should == 200
      response.body.should be_json(Hash)
    end
  end
end
