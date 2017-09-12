class CreateInvitationsService
  def call
    Faker::Config.locale = 'en-US'
    1.upto(9).each do
      FactoryGirl.create :invitation, email: Faker::Internet.free_email
    end
  end
end
