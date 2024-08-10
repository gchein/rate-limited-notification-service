puts 'Seeding users...'
User.destroy_all
10.times do |n|
  user_name  = "Test User #{n + 1}"
  user_email = "test.user_#{n + 1}@example.com"
  user = User.create!(name: user_name, email: user_email)

  puts "#{user.name} created"
end
