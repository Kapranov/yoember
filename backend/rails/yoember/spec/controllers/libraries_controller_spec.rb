require 'rails_helper'

RSpec.describe LibrariesController, type: :controller do
  let(:library) { create(:library) }
  let(:valid_attributes) {
    { name: "Timothy Rosetta Volkman",
      address: "Reinashire 8553 Reinger WalkSuite 780",
      phone: "7552290495"
    }
  }
  let(:invalid_attributes) {
    {name: "", address: "", phone: ""}
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a successful 200 response" do
      get :index, format: :json
      expect_json_types(data: :array)
      expect_status :ok
      expect(response).to be_success
    end

    it "returns all the libraries" do
      get :index, format: :json
    end
  end

  describe "GET index" do
    it "assigns all libraries as @libraries" do
      library = Library.create! valid_attributes
      get :index, {}
      expect(assigns(:libraries)).to eq([library])
    end
  end

  describe "GET #show" do
    before(:each) do
      get :show, params: { id: library.id }
    end

    it "returns the information name, address, phone on a hash" do
      expect(json_response[:name]).eql?(library.name)
      expect(json_response[:address]).eql?(library.address)
      expect(json_response[:phone]).eql?(library.phone)
    end

    it { should respond_with 200 }
  end

  describe "GET #new" do
    it "assigns a new library as @library" do
      get :create, {}
      expect(assigns(:library)).to be_a_new(Library)
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      delete :destroy, params: { id: library.id }
    end
  end

  context "when request sets accept => application/json" do
    it "should return successful response" do
      request.accept = "application/json"
      get :index
      expect(response).to be_successful
    end
  end
end
