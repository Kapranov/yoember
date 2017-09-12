require 'rails_helper'

RSpec.describe Invitation, type: :model do
  before { @invitation = FactoryGirl.create(:invitation) }

  subject { @invitation }

  it { should respond_to(:email) }

  it { should be_valid }

  it { should validate_presence_of(:email) }
  it { should allow_value('example@domain.com').for(:email) }

  describe "creation" do
    it "can be created if valid" do
      expect(@invitation).to be_valid
    end

    it "will not be created if not valid" do
      @invitation.email = nil
      expect(@invitation).to_not be_valid
    end
  end

  describe 'When email' do
    it "is not present" do
      expect(build(:invitation_with_blank_email)).to be_invalid
    end

    it "should be invalid" do
      addresses = %w[user@foo,com user_at_bar.org this.user@blah.]
      addresses.each do |invalid_address|
        @invitation.email = invalid_address
        expect(@invitation).to be_invalid
      end
    end

    it "format is valid" do
      addresses = %w[me@foo.com A_FINE_USER@f.b.org my.humps@blog.jp a+b@bots.gr]
      addresses.each do |valid_address|
        @invitation.email = valid_address
        expect(@invitation).to be_valid
      end
    end

    it "is already taken" do
      @invitation.save
      expect(Invitation.new(@invitation.attributes)).to be_invalid
    end
  end
end
