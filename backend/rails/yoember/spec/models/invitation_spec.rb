require 'rails_helper'

RSpec.describe Invitation, type: :model do
  subject { described_class.new }

  fixtures :invitations
  it "fixture method defined" do
    invitations(:one)
  end

  it "is valid with valid attributes" do
    subject.email = "MyString"
    expect(subject).to be_valid
  end

  it "is not valid without a email" do
    expect(subject).to_not be_valid
  end
end
