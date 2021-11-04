class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(7)
    # @notifications.where(checked: false).each do |notification|
    #   notification.update_attributes(checked: true)
    # end
  end

  def update
    notification = Notification.find(params[:id])
    notification.update_attributes(checked: true)
    redirect_to request.referer
  end

  def destroy_all
    #通知を全削除
    @notifications = current_user.passive_notifications
    @notifications.destroy_all
    redirect_to request.referer
  end
end
