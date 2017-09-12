FactoryGirl.define do
  factory :invitation do
    sequence(:email) { "#{Faker::Internet.free_email}" }

    factory :invitation_with_blank_email do
      email ''
    end
  end
end
