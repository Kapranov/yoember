require "rails_helper"

RSpec.describe InvitationsController, :type => :routing do
  describe "#Routing" do
    it "routes to index" do
      expect(get: "/invitations").to route_to("invitations#index")
    end

    it "routes to show" do
      expect(get: "/invitations/1").to route_to("invitations#show", id: "1")
    end

    it "routes to create" do
      expect(post: "/invitations").to route_to("invitations#create")
    end

    it "routes to update" do
      expect(put: "/invitations/1").to route_to("invitations#update", id: "1")
    end

    it "routes to destroy" do
      expect(delete: "/invitations/1").to route_to("invitations#destroy", id: "1")
    end
  end
end
