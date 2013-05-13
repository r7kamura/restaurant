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
    Recipe.create(:title => "title")
  end

  let(:other_recipe) do
    Recipe.create(:title => "other title")
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

      it do
        get "/recipes", nil, env
        response.status.should == 401
      end
    end

    it do
      get "/recipes", nil, env
      response.status.should == 200
      response.body.should be_json(
        [
          lambda {|hash| hash["id"] == recipe.id },
          lambda {|hash| hash["id"] == other_recipe.id },
        ]
      )
    end

    context "with where params" do
      it do
        get "/recipes", { :where => { :title => { :eq => "title" } } }, env
        response.status.should == 200
        response.body.should be_json([Hash])
      end
    end

    context "with order params" do
      it do
        get "/recipes", { :order => "-id" }, env
        response.status.should == 200
        response.body.should be_json(
          [
            lambda {|hash| hash["id"] == other_recipe.id },
            lambda {|hash| hash["id"] == recipe.id },
          ]
        )
      end
    end
  end

  describe "GET /recipes/:id" do
    it do
      get "/recipes/#{recipe.id}", nil, env
      response.status.should == 200
      response.body.should be_json(Hash)
    end
  end
end
