class Notification < ApplicationRecord
  NOTIFICATION_TYPES = ["Status Update", "Daily News", "Project Invitation", "Marketing"]

  belongs_to :user

  scope :creation_window, -> (time_window_as_symbol) {
    where('created_at > ?', 1.send(time_window_as_symbol).ago)
  }

  scope :count_notifications_by_user_and_type, -> (params = {}) {
    where(
      user: params[:user],
      notification_type: params[:notification_type]
    ).count
  }

  validates :notification_type, :message, presence: true
  validates :notification_type, inclusion: { in: NOTIFICATION_TYPES }

  validate :can_send_to_user?, on: :create

  private

  def can_send_to_user?
    if validate_ruleset == false
      errors.add(:base, "Max Notification Limit reached")
    end
  end

  def validate_ruleset
    window_limit_rule_hash = find_rule

    window_limit_rule_hash&.all? { |time_window, max_limit| current_count(time_window) < max_limit }
  end

  def find_rule
    RATE_LIMIT_RULES[notification_type.gsub(' ', '_').downcase.to_sym] unless notification_type.nil?
  end

  def current_count(time_window)
    Notification.creation_window(time_window)
                .count_notifications_by_user_and_type(
                  { user:,
                    notification_type: }
                )
  end
end
