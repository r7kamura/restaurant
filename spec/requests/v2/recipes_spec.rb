require "spec_helper"

describe "/v2/recipes" do
  before do
    self.accept = "application/json"
  end

  let(:application) do
    Doorkeeper::Application.create(:name => "example", "redirect_uri" => "http://example.com")
  end

  let(:access_token) do
    application.access_tokens.create
  end

  let(:params) do
    { :access_token => access_token.token }
  end

  let(:recipe) do
    post "/v2/recipes", { :recipe => { :title => "created" } }
    JSON.parse(response.body)
  end

  let(:id) do
    recipe["_id"]
  end

  let(:non_existent_id) do
    Moped::BSON::ObjectId.new
  end

  describe "POST /v2/recipes" do
    before do
      params[:recipe] = { :title => "created" }
    end

    context "without authentication" do
      before do
        params.delete(:access_token)
      end

      it "returns 401" do
        post "/v2/recipes", params
      end
    end

    context "with authentication" do
      it "creates a new recipe" do
        post "/v2/recipes", params
        response.status.should == 201
      end
    end
  end
end
