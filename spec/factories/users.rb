FactoryBot.define do
  sequence :user_name do |n|
    "Test User #{n}"
  end

  sequence :user_email do |n|
    "test.user_#{n}@example.com"
  end

  factory :user do
    name { generate(:user_name) }
    email { generate(:user_email) }
  end
end
