require "spec_helper"

describe "/v1/ingredients/*" do
  let(:token) do
    FactoryGirl.create(:doorkeeper_access_token)
  end

  let(:env) do
    {
      "HTTP_ACCEPT"        => nil,
      "HTTP_AUTHORIZATION" => "Bearer #{token.token}",
    }
  end

  context "without model definition" do
    it "accepts CRUD requests" do
      post "/v1/ingredients", { :ingredient => { :title => "created" } }, env
      response.should be_created
      response.body.should be_json(Hash)
      id = JSON.parse(response.body)["id"]

      get "/v1/ingredients", nil, env
      response.should be_ok
      response.body.should be_json([Hash])

      put "/v1/ingredients/#{id}", { :ingredient => { :title => "updated" } }, env
      response.should be_no_content

      get "/v1/ingredients/#{id}", nil, env
      response.should be_ok
      JSON.parse(response.body)["title"].should == "updated"

      delete "/v1/ingredients/#{id}", nil, env
      response.should be_no_content

      get "/v1/ingredients/#{id}", nil, env
      response.should be_not_found
    end
  end
end
