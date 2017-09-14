require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:invitation) { create(:invitation) }

  let(:valid_attributes) {
    {email: "test1@test.com"}
  }

  let(:invalid_attributes) {
    {email: ""}
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a successful 200 response" do
      get :index, format: :json
      expect_json_types(data: :array)
      expect_status :ok
      expect(response).to be_success
    end

    it "returns all the invitations" do
      get :index, format: :json
    end
  end

  describe "GET index" do
    it "assigns all invitations as @invitations" do
      invitation = Invitation.create! valid_attributes
      get :index, {}
      expect(assigns(:invitations)).to eq([invitation])
    end
  end

  describe "GET #show" do
    before(:each) do
      get :show, params: { id: invitation.id }
    end

    it "returns the information email on a hash" do
      expect(json_response[:email]).eql?(invitation.email)
    end

    it { should respond_with 200 }
  end

  describe "GET #new" do
    it "assigns a new invitation as @invitation" do
      get :create, {}
      #expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end

  #describe "with valid params" do
  #  it "creates a new invitation" do
  #    expect {
  #      post :create, {:ttt => valid_attributes}
  #    }.to change(Invitation, :count).by(1)
  #    expect { post :create, :invitation => ttt_params }.to change(Invitation, :count).by(1)
  #  end
  #  it "assigns a newly created invitation as @invitation" do
  #    post :create, {:invitation => valid_attributes}
  #    expect(assigns(:invitation)).to be_a(Invitation)
  #    expect(assigns(:invitation)).to be_persisted
  #  end
  #end

  #describe "with invalid params" do
  #  it "assigns a newly created but unsaved invitation as @invitation" do
  #    post :create, {:invitation => invalid_attributes}
  #    expect(assigns(:invitation)).to be_a_new(Invitation)
  #  end
  #end

  #describe "DELETE #destroy" do
  #  before(:each) do
  #    @invitation = FactoryGirl.create :invitation
  #    delete :destroy, params: { id: @invitation.id }
  #  end
  #  it { should respond_with 204 }
  #end

  #describe 'DELETE #destroy' do
  #  before(:each) do
  #    delete :destroy, params: { id: invitation.id }
  #  end

  #  it 'is successful' do
  #    expect(response).to be_successful
  #  end

  #  it 'renders no response body' do
  #    #expect(response.body).to be_empty
  #  end
  #end

  context "when request sets accept => application/json" do
    it "should return successful response" do
      request.accept = "application/json"
      get :index
      expect(response).to be_successful
    end
  end
end
