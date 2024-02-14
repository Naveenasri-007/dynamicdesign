# frozen_string_literal: true

Fabricator(:architect) do
  email           { Faker::Internet.email }
  password        Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true)
  name            Faker::App.name
  number          Faker::PhoneNumber.subscriber_number(length: 10)
  profile_photo   Faker::Internet.url
end
