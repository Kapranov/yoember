require 'rails_helper'

RSpec.describe 'Invitations API', type: :request do
  include_context 'API'

  #let!(:invitations) { create_list(:invitation, 1) }
  #let(:invitation_id) { invitations.first.id }

  describe 'GET /invitations' do
    let!(:invitation) { create(:invitation) }
    let(:payload) do
      {
        data: {
          type: 'invitations',
          attributes: { email: 'xxxxx@xxxxxx.xxx' }
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
      specify do
        #expect(response.header['Content-Type']).to include 'application/vnd.api+json'
        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(200)

        expect(invitation).not_to be_nil
        expect(json_response).not_to be_empty
        expect(json_response.size).to eq 2
        expect(json_response.count).to eq 2
        expect(json_response.length).to eq 2
        expect(response).to match_response_schema('invitation')
        #expect(json_response.first).to eq invitation.email
        #expect(json_body['data'].first['invitation']['email']).to eq invitation.email

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

      #expect_json_types(data: :array)
    end
  end

  #describe 'GET /invitations/:id' do
  #  before { get "/invitations/#{invitation_id}" }

  #  context 'when the record exists' do
  #    it 'returns the invitation' do
  #      expect(json).not_to be_empty
  #      expect(json['id']).to eq(invitation_id)
  #    end

  #    it 'returns status code 200' do
  #      expect(response).to have_http_status(200)
  #    end
  #  end

  #  context 'when the record does not exist' do
  #    let(:invitation_id) { 11 }

  #    it 'returns status code 404' do
  #      expect(response).to have_http_status(404)
  #    end

  #    it 'returns a not found message' do
  #      expect(response.body).to match(/Couldn't find Invitation/)
  #    end
  #  end
  #end

  def jsonapify opts
    data = opts.slice(:type, :id, :attributes, :relationships)
    data = data.deep_transform_keys { |key| key.to_s.dasherize.to_sym }
    { data: data }.to_json
  end
end
