class Notification < ApplicationRecord
  NOTIFICATION_TYPES = ["Status Update", "Daily News", "Project Invitation", "Marketing"]

  belongs_to :user

  scope :count_notifications_by_user_and_type, -> (user) {
    where(user: user).group(:notification_type).count
  }

  validates :notification_type, :message, presence: true
  validates :notification_type, inclusion: { in: NOTIFICATION_TYPES }
end
