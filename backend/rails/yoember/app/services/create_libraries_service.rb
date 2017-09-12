class CreateLibrariesService
  def call
    Faker::Config.locale = 'en-US'
    1.upto(9).each do
      FactoryGirl.create :library,
        name: Faker::Name.name_with_middle,
        address: "#{Faker::Address.city}" + " #{Faker::Address.street_address}" + ' ' + "#{Faker::Address.secondary_address}",
        phone: Faker::PhoneNumber.subscriber_number(10)
    end
  end
end
