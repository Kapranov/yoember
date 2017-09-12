require 'rails_helper'

RSpec.describe LibrariesController, type: :controller do
  describe "GET index" do
    it "returns a successful 200 response" do
      get :index, :format => 'json'
      expect_json_types(data: :array)
      expect_status :ok
      expect(response).to be_success
    end

    it "returns all the invitations" do
      get :index, format: :json
    end
  end
end
