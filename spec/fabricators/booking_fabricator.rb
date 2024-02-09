# frozen_string_literal: true

Fabricator(:booking) do
  expected_amount Faker::Number.positive.to_i
  expected_months Faker::Number.positive.to_i
  architect_id    Faker::Number.positive.to_i
  design_name     Faker::App.name
  design_url      Faker::Internet.url
  message         Faker::Lorem.paragraph
end
