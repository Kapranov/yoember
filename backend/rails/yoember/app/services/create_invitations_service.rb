class CreateInvitationsService
  def call
    1.upto(3).each do
      FactoryGirl.create :invitation, email: Faker::Internet.free_email
    end
  end
end
