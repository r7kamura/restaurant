require "spec_helper"

describe "/v2/recipes/*" do
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

  describe "/v2/recipes" do
    it "returns 200" do
      get "/v2/recipes", nil, env
      response.should be_ok
    end
  end

  describe "/v2/recipes/:id" do
    it "returns 404" do
      expect do
        get "/v2/recipe/#{recipe.id}", nil, env
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
