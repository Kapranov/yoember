require 'rails_helper'

RSpec.describe Library, type: :model do
  before { @library = FactoryGirl.create(:library) }

  subject { @library }

  it { should respond_to(:name) }
  it { should respond_to(:address) }
  it { should respond_to(:phone) }

  it { should be_valid }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:phone) }
  it { should allow_value('Tyshawn Johns Sr.').for(:name) }
  it { should allow_value('Imogeneborough 282 Kevin Brook Apt. 672').for(:address) }
  it { should allow_value('12345678').for(:phone) }

  describe "creation" do
    it "can be created if valid" do
      expect(@library).to be_valid
    end

    it "will not be created if not valid" do
      @library.name = nil
      @library.address = nil
      @library.phone = nil
      expect(@library).to_not be_valid
    end
  end
end
