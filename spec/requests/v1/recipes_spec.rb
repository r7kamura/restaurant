require "spec_helper"

describe "/v1/recipes" do
  before do
    self.accept = "application/json"
  end

  let(:recipe) do
    post "/v1/recipes", :recipe => { :title => "created" }
    JSON.parse(response.body)
  end

  let(:another_recipe) do
    post "/v1/recipes", :recipe => { :title => "another" }
    JSON.parse(response.body)
  end

  let(:id) do
    recipe["_id"]
  end

  let(:non_existent_id) do
    Moped::BSON::ObjectId.new
  end

  describe "GET /v1/recipes" do
    before do
      recipe
      another_recipe
    end

    it "return recipes" do
      get "/v1/recipes"
      response.status.should == 200
      response.body.should be_json([recipe, another_recipe])
    end

    context "with filter query" do
      it "filters recipes" do
        get "/v1/recipes", :filter => { :title => { "$ne" => "created" } }
        response.status.should == 200
        response.body.should be_json([another_recipe])
      end
    end

    context "with sort query" do
      it "sorts recipes" do
        get "/v1/recipes", :sort => { :title => 1 }
        response.status.should == 200
        response.body.should be_json([another_recipe, recipe])
      end
    end
  end

  describe "GET /v1/recipes/:id" do
    context "with existent id" do
      it "returns the recipe" do
        get "/v1/recipes/#{id}"
        response.status.should == 200
        response.body.should be_json(recipe)
      end
    end

    context "with non-existent id" do
      it "returns 404" do
        get "/v1/recipes/#{non_existent_id}"
        response.status.should == 404
      end
    end

    context "with invalid id" do
      it "returns 404" do
        get "/v1/recipes/0"
        response.status.should == 404
      end
    end
  end

  describe "POST /v1/recipes" do
    it "creates a new recipe" do
      post "/v1/recipes", :recipe => { :title => "created" }
      response.status.should == 201
      response.body.should be_json("_id" => /\A[a-f0-9]{24}\z/, "title" => "created")
      response.location.should =~ %r<http://www\.example\.com/v1/recipes/[a-f0-9]{24}>
    end
  end

  describe "PUT /v1/recipes/:id" do
    context "with existent id" do
      it "updates the recipe" do
        put "/v1/recipes/#{id}", :recipe => { :title => "updated" }
        response.status.should == 204

        get "/v1/recipes/#{id}"
        response.body.should be_json("_id" => id, "title" => "updated")
      end
    end

    context "with non-existent id" do
      it "returns 404" do
        put "/v1/recipes/#{non_existent_id}", :recipe => { :title => "updated" }
        response.status.should == 404
      end
    end
  end

  describe "DELETE /v1/recipes/:id" do
    context "with existent id" do
      it "deletes the recipe" do
        delete "/v1/recipes/#{id}"
        response.status.should == 204

        get "/v1/recipes/#{id}"
        response.status.should == 404
      end
    end

    context "with non-existent id" do
      it "returns 404" do
        delete "/v1/recipes/#{non_existent_id}"
        response.status.should == 404
      end
    end
  end
end
