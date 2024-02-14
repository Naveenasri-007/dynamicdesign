# frozen_string_literal: true

Fabricator(:comment) do
  content { Faker::Lorem.paragraph }
end
