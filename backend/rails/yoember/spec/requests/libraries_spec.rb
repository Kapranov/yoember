require 'rails_helper'

RSpec.describe LibrariesController, type: :request do
  include_context 'API'

  describe 'GET index' do
    let(:payload) do
      {
        data: {
          type: 'libraries',
          attributes: {
            name: 'North Art 76108 Pink CornersApt. 140',
            address: 'lindsey@gmail.com',
            phone: '1352168479'
          }
        }
      }
    end

    context 'get all libraries' do
      let!(:library) { create(:library) }

      before { api_get 'libraries' }

      it "works correctly" do
        expect(response.header['Content-Type']).to include 'application/vnd.api+json'
        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(200)
        expect(json_items.length).to eq(1)
        jsonapi_post("/libraries", payload)
      end

      specify do
        expect(response).to match_response_schema('library')
        expect(json_response).to include_json({
          data: [{
            id: "#{library.id}",
            type: "libraries",
            attributes: {
              name: "#{library.name}",
              address: "#{library.address}",
              phone: "#{library.phone}"
            },
            links: {
              self: "http://api.dev.local:3000/libraries/#{library.id}"
            }
          }]
        })
      end
    end
  end
end
