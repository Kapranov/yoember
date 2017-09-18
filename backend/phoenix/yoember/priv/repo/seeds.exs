alias Yoember.Repo
alias Yoember.Invitations.Invitation
alias Yoember.Libraries.Library
alias Faker, as: Faker

for _ <- 1..9 do
  Repo.insert!(%Invitation{
    email: Faker.Internet.free_email
  })
  Repo.insert!(%Library{
    name: Faker.Name.name,
    address: Enum.join([Faker.Address.street_address(true), " ", Faker.Address.city]),
    phone: Faker.Phone.EnUs.extension(10)
  })
end
