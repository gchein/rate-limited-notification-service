class Notification < ApplicationRecord
  NOTIFICATION_TYPES = ["Status Update", "Daily News", "Project Invitation"]

  belongs_to :user

  validates :notification_type, :message, presence: true
  validates :notification_type, inclusion: { in: NOTIFICATION_TYPES }
end
