FactoryBot.define do
  sequence :message_sample do |n|
    "Message #{n}"
  end

  factory :notification do
    notification_type { Notification::NOTIFICATION_TYPES.sample }
    message { generate(:message_sample) }
    association :user
  end
end
