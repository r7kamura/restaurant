require "spec_helper"

describe "/v1/recipes/*" do
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

  it "accepts CRUD requests" do
    post "/v1/recipes", { :recipe => { :title => "created" } }, env
    response.should be_created
    response.body.should be_json(Hash)
    id = JSON.parse(response.body)["id"]

    get "/v1/recipes", nil, env
    response.should be_ok
    response.body.should be_json([Hash])

    put "/v1/recipes/#{id}", { :recipe => { :title => "updated" } }, env
    response.should be_no_content

    get "/v1/recipes/#{id}", nil, env
    response.should be_ok
    JSON.parse(response.body)["title"].should == "updated"

    delete "/v1/recipes/#{id}", nil, env
    response.should be_no_content

    get "/v1/recipes/#{id}", nil, env
    response.should be_not_found
  end

  context "with overwritten model" do
    context "with validation" do
      context "with invalid attributes" do
        it "returns 422" do
          post "/v1/recipes", nil, env
          be_unprocessable_entity
        end
      end
    end
  end
end
