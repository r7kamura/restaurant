require "spec_helper"

describe "/v1/recipes" do
  let(:env) do
    { "HTTP_ACCEPT" => nil }
  end

  let(:recipe) do
    post "/v1/recipes", { :recipe => { :title => "created" } }, env
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
      get "/v1/recipes", nil, env
      response.status.should == 200
      response.body.should be_json([recipe])
    end
  end

  describe "GET /v1/recipes/:id" do
    it "returns the recipe" do
      get "/v1/recipes/#{id}", nil, env
      response.status.should == 200
      response.body.should be_json(recipe)
    end
  end

  describe "POST /v1/recipes" do
    it "creates a new recipe" do
      post "/v1/recipes", { :recipe => { :title => "created" } }, env
      response.status.should == 201
      response.body.should be_json(
        "_id" => /\A[a-f0-9]{24}\z/,
        "title" => "created"
      )
    end
  end

  describe "PUT /v1/recipes/:id" do
    it "updates the recipe" do
      put "/v1/recipes/#{id}", { :recipe => { :title => "updated" } }, env
      response.status.should == 204
      get "/v1/recipes/#{id}", nil, env
      response.body.should be_json(
        "_id" => id,
        "title" => "updated"
      )
    end
  end

  describe "DELETE /v1/recipes/:id" do
    it "deletes the recipe" do
      delete "/v1/recipes/#{id}", nil, env
      response.status.should == 204
    end
  end
end
