FactoryGirl.define do
  sequence :address do
    "#{Faker::Address.city}" + " #{Faker::Address.street_address}" + ' ' + "#{Faker::Address.secondary_address}"
  end

  factory :library do
    name "#{Faker::Name.name}"
    address { generate :address }
    phone "#{Faker::PhoneNumber.subscriber_number(8)}"
  end
end
