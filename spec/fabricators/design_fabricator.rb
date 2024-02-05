Fabricator(:design) do
  design_name     Faker::App.name
  style           Faker::App.name
  price_per_sqft  Faker::Number.positive.to_i
  square_feet     Faker::Number.positive.to_i
  category       'livingroom'
  floorplan      '2BHK'
  time_required   Faker::Number.positive.to_i
  bio             Faker::Lorem.paragraph_by_chars(number: 40, supplemental: false)
  brief           Faker::Lorem.paragraph_by_chars(number: 2000, supplemental: false)
  design_url      Faker::Internet.url
end
