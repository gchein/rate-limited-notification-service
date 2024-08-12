class Notification < ApplicationRecord
  NOTIFICATION_TYPES = RATE_LIMIT_RULES.keys.map { |key| key.to_s.titleize }.freeze

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

  before_validation :adjust_notification_type_spelling

  private

  def can_send_to_user?
    if validate_ruleset == false && !message.blank?
      errors.add(:base, "Max Notification Limit reached")
    end
  end

  def validate_ruleset
    window_limit_rule_hash = find_rule

    window_limit_rule_hash&.all? { |time_window, max_limit| current_count(time_window) < max_limit }
  end

  def find_rule
    RATE_LIMIT_RULES[notification_type.parameterize(separator: "_").to_sym] unless notification_type.nil?
  end

  def current_count(time_window)
    Notification.creation_window(time_window)
                .count_notifications_by_user_and_type(
                  { user:,
                    notification_type: }
                )
  end

  def adjust_notification_type_spelling
    self.notification_type = notification_type.downcase.squish.titleize unless notification_type.nil?
  end
end
