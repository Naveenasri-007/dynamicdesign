Fabricator(:user) do
  email                  Faker::Internet.email
  password               'Navee@123'
  name                   Faker::Name.name
  phone_number           '9876543212'
  # Faker::PhoneNumber.phone_number
  # Faker::Internet.password
end
