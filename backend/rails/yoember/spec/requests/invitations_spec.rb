require 'rails_helper'

RSpec.describe "Invitations", :type => :request do
  describe "GET /invitations" do
    it "returns all the invitations" do
      FactoryGirl.create :invitation, email: 'test_one@example.com'
      FactoryGirl.create :invitation, email: 'test_two@example.com'

      get '/invitations'

      expect(response.status).to eq 200

      body = JSON.parse(response.body)
      invitation_emails = body['data'].map{|invitation| invitation['attributes']['email'] }
      expect(invitation_emails).to match_array(['test_one@example.com', 'test_two@example.com'])
    end
  end
end
