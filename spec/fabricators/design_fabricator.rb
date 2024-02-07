Fabricator(:design) do
  design_name    Faker::Lorem.paragraph_by_chars(number: 30)
  style           Faker::App.name
  price_per_sqft  Faker::Number.positive.to_i
  square_feet     Faker::Number.positive.to_i
  category       %w[bedroom livingroom kitchen bathroom].sample
  floorplan      ['2BHK', '3BHK', '3+BHK', '1BHK'].sample
  time_required   Faker::Number.positive.to_i
  bio             Faker::Lorem.paragraph_by_chars(number: 40)
  brief           Faker::Lorem.paragraph_by_chars(number: 2000)
  design_url      Faker::Internet.url
end
