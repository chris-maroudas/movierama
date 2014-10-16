# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Users creation

12.times do
  password = Faker::Internet.password(8)
  data = {
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
  }
  User.create(data)
end

5.times do
  data = {
    title: Faker::Lorem.word,
    description: Faker::Lorem.paragraph(2),
    user: User.all.sample,
    published_at: rand(99.years).ago.to_date
  }
  Movie.create(data)
end

100.times do
  choices = [true, false]
  data = {
    positive: choices.sample,
    user: User.all.sample,
    movie: Movie.all.sample
  }
  rating = Rating.new(data)
  rating.save if rating.valid?
end
