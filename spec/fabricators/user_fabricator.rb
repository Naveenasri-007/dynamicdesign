Fabricator(:user) do
  email               Faker::Internet.email
  password            Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true)
  name                Faker::App.name
  phone_number        Faker::PhoneNumber.subscriber_number(length: 10)
end
