# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Seeding Users"
User.create!(email: 'yshmarov@gmail.com', password: 'yshmarov@gmail.com', password_confirmation: 'yshmarov@gmail.com')
User.create!(email: 'yashm@outlook.com', password: 'yashm@outlook.com', password_confirmation: 'yashm@outlook.com')
User.create!(email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com')

puts "Seeding Categories"
3.times do
  Category.create!([{
    name: Faker::Educator.degree,
    description: Faker::Lorem.paragraph,
  }])
end

puts "Seeding Course"
50.times do
  Course.create!([{
    name: Faker::Educator.course_name,
    short_description: Faker::Lorem.paragraph,
    description: Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4),
    user_id: Faker::Number.between(from: 1, to: 3),
    category_id: Faker::Number.between(from: 1, to: 3),
    duration: Faker::Number.between(from: 0, to: 600),
    price: Faker::Number.between(from: 0, to: 200),
    published: true,
    approved: true,
    language: "English"
  }])
end

puts "Seeding Lesson"
90.times do
  Lesson.create!([{
    name: Faker::Address.unique.city,
    description: Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4),
    video_url: "https://www.youtube.com/watch?v=ojXjR33bPOY",
    course_id: Faker::Number.between(from: 1, to: 9),
    row_order: Faker::Number.between(from: -50000, to: 50000),
  }])
end

puts "Seeding Subscriptions"
30.times do
  user = User.take
  # We don't want to subscribe a user to a course they made
  course = Course.where.not(user_id: user).
    # AND we don't want to subscribe a user to a course they're already
    # subscribed to
    where.not(id: user.subscriptions.pluck(:course_id)).take

  Subscription.create!([{
    rating: Faker::Number.between(from: 1, to: 5),
    comment: Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4),
    course_id: course.id,
    user_id: user.id,
  }])
end
