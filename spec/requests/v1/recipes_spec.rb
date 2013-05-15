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

    post "/v1/recipes", { :recipe => { :title => "another" } }, env

    get "/v1/recipes", { :where => { :title => { :eq => "another" } } }, env
    response.body.should be_json([Hash])

    get "/v1/recipes", { :order => "title" }, env
    response.should be_forbidden

    get "/v1/recipes", { :order => "-id" }, env
    response.body.should be_json(
      [
        lambda {|recipe| recipe["title"] == "another" },
        lambda {|recipe| recipe["title"] == "updated" },
      ]
    )

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
