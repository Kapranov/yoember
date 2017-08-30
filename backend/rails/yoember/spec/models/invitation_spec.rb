require 'rails_helper'

RSpec.describe Invitation, type: :model do
  subject { described_class.new }

  fixtures :invitations

  it "fixture method defined" do
    invitations(:one)
  end

  it "is valid with valid attributes" do
    subject.email = "test@example.com"
    expect(subject).to be_valid
  end

  it "is not valid without a email" do
    expect(subject).to_not be_valid
  end

  it { is_expected.to callback(:downcase_fields).before(:save) }
  it { should respond_to :email }
  it { should validate_presence_of :email }
  it { should validate_length_of(:email).is_at_least(5) }
  it { should validate_length_of(:email).is_at_most 25 }
  it { should validate_uniqueness_of(:email).case_insensitive }
end
