require 'rails_helper'

RSpec.describe InvitationsController, type: :request do
  include_context 'API'

  describe 'GET /invitations' do
    let!(:invitation) { create(:invitation) }
    let(:payload) do
      {
        data: {
          type: 'invitations',
          attributes: {
            email: 'stella@yahoo.com'
          }
        }
      }
    end

    before { api_get 'invitations' }

    it "works correctly" do
      expect(response.status).to eq(200)
      expect(json_items.length).to eq(1)
      jsonapi_post("/invitations", payload)
    end

    context 'returns invitations' do
      before { api_get 'invitations' }
      specify do
        expect(response.header['Content-Type']).to include 'application/vnd.api+json'
        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(200)

        expect(invitation).not_to be_nil
        expect(json_response).not_to be_empty
        expect(json_response.size).to eq 2
        expect(json_response.count).to eq 2
        expect(json_response.length).to eq 2
        expect(response).to match_response_schema('invitation')
        expect(json_response).to include_json({
          data: [{
            id: "#{invitation.id}",
            type: "invitations",
            attributes: {
              email: "#{invitation.email}"
            },
            links: {
              self: "http://api.dev.local:3000/invitations/#{invitation.id}"
            }
          }]
        })
      end

      # invitation_ids = json_response['data'].map{ |unit| unit['attributes']['emails'].to_i }
      # expect(invitation_ids).to eq([1])
      # invitation_emails = json_response['data'].map{|invitation| invitation['attributes']['email'] }
      # expect(invitation_emails).to match_array(["demo1@example.com"])
    end
  end
end
