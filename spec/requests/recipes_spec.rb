require "spec_helper"

describe "requests to recipes" do
  let(:token) do
    FactoryGirl.create(:doorkeeper_access_token)
  end

  let(:env) do
    {
      "HTTP_ACCEPT"        => nil,
      "HTTP_AUTHORIZATION" => "Bearer #{token.token}",
    }
  end

  let(:recipe) do
    FactoryGirl.create(:recipe)
  end

  let(:other_recipe) do
    FactoryGirl.create(:recipe)
  end

  describe "GET /recipes" do
    before do
      recipe
      other_recipe
    end

    context "without authentication" do
      before do
        env.delete("HTTP_AUTHORIZATION")
      end

      it "returns 401" do
        get "/recipes", nil, env
        response.should be_unauthorized
      end
    end

    it "returns recipes" do
      get "/recipes", nil, env
      response.should be_ok
      response.body.should be_json([Hash, Hash])
    end

    context "with where params" do
      it "filters recipes" do
        get "/recipes", { :where => { :title => { :eq => recipe.title } } }, env
        response.should be_ok
        response.body.should be_json([Hash])
      end
    end

    context "with order params" do
      it "sorts recipes" do
        get "/recipes", { :order => "-id" }, env
        response.should be_ok
        response.body.should be_json(
          [
            lambda {|hash| hash["id"] == other_recipe.id },
            lambda {|hash| hash["id"] == recipe.id },
          ]
        )
      end
    end

    context "with not-allowed order params" do
      it "returns 403" do
        get "/recipes", { :order => "title" }, env
        response.should be_forbidden
      end
    end
  end

  describe "GET /recipes/:id" do
    it "returns a recipe" do
      get "/recipes/#{recipe.id}", nil, env
      response.should be_ok
      response.body.should be_json(Hash)
    end
  end

  describe "POST /recipes" do
    it "creates a recipe" do
      post "/recipes", { :recipe => { :title => "created" } }, env
      response.should be_created
      response.body.should be_json(Hash)
      Recipe.first.title.should == "created"
    end

    context "with invalid attributes" do
      it "returns 422" do
        post "/recipes", nil, env
        be_unprocessable_entity
      end
    end
  end

  describe "PUT /recipes/:id" do
    it "updates a recipe" do
      put "/recipes/#{recipe.id}", { :recipe => { :title => "updated" } }, env
      response.should be_no_content
      recipe.reload.title.should == "updated"
    end

    context "with invalid attributes" do
      it "returns 422" do
        put "/recipes/#{recipe.id}", { :recipe => { :title => nil } }, env
        be_unprocessable_entity
      end
    end
  end

  describe "DELETE /recipes/:id" do
    it "destroyes a recipe" do
      delete "/recipes/#{recipe.id}", nil, env
      response.should be_no_content
      Recipe.should have(0).recipe
    end
  end
end
