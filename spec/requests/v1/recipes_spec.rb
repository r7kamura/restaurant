require "spec_helper"

describe "/v1/recipes" do
  before do
    self.accept = "application/json"
  end

  let(:recipe) do
    post "/v1/recipes", { :recipe => { :title => "created" } }
    JSON.parse(response.body)
  end

  let(:id) do
    recipe["_id"]
  end

  describe "GET /v1/recipes" do
    before do
      recipe
    end

    it "return recipes" do
      get "/v1/recipes"
      response.status.should == 200
      response.body.should be_json([recipe])
    end
  end

  describe "GET /v1/recipes/:id" do
    it "returns the recipe" do
      get "/v1/recipes/#{id}"
      response.status.should == 200
      response.body.should be_json(recipe)
    end
  end

  describe "POST /v1/recipes" do
    it "creates a new recipe" do
      post "/v1/recipes", { :recipe => { :title => "created" } }
      response.status.should == 201
      response.body.should be_json(
        "_id" => /\A[a-f0-9]{24}\z/,
        "title" => "created"
      )
      id = JSON.parse(response.body)["_id"]
      response.location.should == "http://www.example.com/v1/recipes/#{id}"
    end
  end

  describe "PUT /v1/recipes/:id" do
    it "updates the recipe" do
      put "/v1/recipes/#{id}", { :recipe => { :title => "updated" } }
      response.status.should == 204
      get "/v1/recipes/#{id}"
      response.body.should be_json(
        "_id" => id,
        "title" => "updated"
      )
    end
  end

  describe "DELETE /v1/recipes/:id" do
    it "deletes the recipe" do
      delete "/v1/recipes/#{id}"
      response.status.should == 204
    end
  end
end
