Fabricator(:rating) do
  value Faker::Number.between(from: 1, to: 5)
end
