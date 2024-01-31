Fabricator(:architect) do 
    email           Faker::Internet.email
    password        'Navee@123'
    name            Faker::Name.name
    number          '9876543212'
    profile_photo   'https://media.designcafe.com/wp-content/uploads/2023/01/31151510/contemporary-interior-design-ideas-for-your-home.jpg'
end 