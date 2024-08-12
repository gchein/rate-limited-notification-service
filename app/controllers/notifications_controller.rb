class NotificationsController < ApplicationController
  def create
    unless params[:notification].present?
      render json: { errors: "Please send a valid request body" }, status: :unprocessable_entity
      return
    end

    @notification = Notification.new(notification_params)

    if @notification.save
      render json: "Sending message to user \'#{@notification.user.name}\'\n\n#{@notification.message}\n"
    else
      render json: { errors: @notification.errors.as_json(full_messages: true) }, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:notification_type, :message, :user_id)
  end
end
