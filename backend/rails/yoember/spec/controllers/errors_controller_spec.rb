require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do
  describe "404 page" do
    it "is not found" do
      get :not_found, format: :json
      expect_status :ok
      expect(response).to be_success
      expect_json_types(errors: :array)
      expect_json(errors: ["Not Found"])
      expect(headers).to_not be(nil)
      expect(json_body).to be_kind_of(Hash)
      expect_json(errors: -> (errors){ expect(errors.length).to eq(1) })
      expect_json_sizes(errors: 1)
      expect_json_sizes(meta: 2)
      expect_json_types('meta', optional(copyright: :string, licence: :string))
      expect(headers).to be_kind_of(Hash)
      expect(json_body.first[0]).to be_kind_of(Symbol)
    end
  end

  describe "422 page" do
    it "is unprocessable entity" do
      get :unacceptable, format: :json
      expect_status :ok
      expect(response).to be_success
      expect_json_types(errors: :array)
      expect_json(errors: ["Unprocessable Entity"])
      expect(headers).to_not be(nil)
      expect(json_body).to be_kind_of(Hash)
      expect_json(errors: -> (errors){ expect(errors.length).to eq(1) })
      expect_json_sizes(errors: 1)
      expect_json_sizes(meta: 2)
      expect_json_types('meta', optional(copyright: :string, licence: :string))
      expect(headers).to be_kind_of(Hash)
      expect(json_body.first[0]).to be_kind_of(Symbol)
    end
  end

  describe "500 page" do
    it "is internal server error" do
      get :internal_server_error, format: :json
      expect_status :ok
      expect(response).to be_success
      expect_json_types(errors: :array)
      expect_json(errors: ["Internal Server Error"])
      expect(headers).to_not be(nil)
      expect(json_body).to be_kind_of(Hash)
      expect_json(errors: -> (errors){ expect(errors.length).to eq(1) })
      expect_json_sizes(errors: 1)
      expect_json_sizes(meta: 2)
      expect_json_types('meta', optional(copyright: :string, licence: :string))
      expect(headers).to be_kind_of(Hash)
      expect(json_body.first[0]).to be_kind_of(Symbol)
    end
  end
end
