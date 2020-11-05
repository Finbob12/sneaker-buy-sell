# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

for i in 1..5
    User.create(
        username: "username#{i}",
        email: "#{i}@example.com",
        password: "123456"
    )
    puts "created #{i} users"
end

for i in 1..20
    Listing.create(
        brand: Faker::Company.name,
        style: Faker::Color.color_name,
        size: Faker::Number.between(from: 6, to: 13),
        description: Faker::Lorem.paragraph(sentence_count: rand(2..10)),
        price: Faker::Number.between(from: 50, to: 1000), 
        user_id: Faker::Number.between(from: 1, to: 5)
        )
    puts "Created #{i} listings"
end