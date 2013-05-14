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
end
