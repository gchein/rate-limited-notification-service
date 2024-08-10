class NotificationsController < ApplicationController
  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      render json: @notification
    else
      render json: { errors: @notification.errors.as_json(full_messages: true) }, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:notification_type, :message, :user_id)
  end
end
