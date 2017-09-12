require "rails_helper"

RSpec.describe ApplicationController, :type => :routing do
  describe "#GET /" do
    it "routes to root of the application" do
      expect(get: "/").to route_to("invitations#index")
    end
  end
end
