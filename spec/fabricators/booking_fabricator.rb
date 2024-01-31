Fabricator(:booking) do
  expected_amount { Faker::Number.positive.to_i }
  expected_months { Faker::Number.positive.to_i }
  architect_id { Faker::Number.positive.to_i }
  design_name { Faker::Lorem.word }
  design_url 'https://cityfurnish.com/blog/wp-content/uploads/2023/09/modren-room-home-interior-design-min-1200x900.jpg'
  message { Faker::Lorem.sentence }
end
