require "test_helper"

describe InvitationsController do
  describe "GET :index" do
    before do
      get :index, format: :json
    end
  end

  it "should be successful" do
    must_respond_with :success
  end
end
