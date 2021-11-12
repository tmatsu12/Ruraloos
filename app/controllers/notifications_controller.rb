class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(7)
  end

  def update
    notification = Notification.find(params[:id])
    notification.update_attributes(checked: true)
    redirect_to request.referer
  end

  def destroy_all
    # 通知を全削除
    @notifications = current_user.passive_notifications
    @notifications.destroy_all
    redirect_to request.referer
  end
end
