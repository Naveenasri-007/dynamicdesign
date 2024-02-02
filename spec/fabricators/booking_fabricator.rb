Fabricator(:booking) do
  expected_amount { 2_000_000 }
  expected_months { 3 }
  architect_id 1
  design_name 'Minimalism'
  design_url 'https://treehouse.co/uploads/styl-boho.jpg'
  message 'Boho style is a free-spirited aesthetic that mixes different cultures and artistic expressions into an eclectic style with an emphasis on organic elements and nature.'
  # expected_amount { Faker::Number.positive.to_i }
  # expected_months { Faker::Number.positive.to_i }
  # architect_id { Faker::Number.positive.to_i }
  # design_name { Faker::Lorem.word }
  # design_url 'https://cityfurnish.com/blog/wp-content/uploads/2023/09/modren-room-home-interior-design-min-1200x900.jpg'
  # message { Faker::Lorem.sentence }
end
