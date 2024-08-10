FactoryBot.define do
  sequence :user_name do |n|
    "Test User #{n + 1}"
  end

  sequence :user_email do |n|
    "test.user_#{n + 1}@example.com"
  end

  factory :user do
    name { generate(:user_name) }
    email { generate(:user_email) }
  end
end
