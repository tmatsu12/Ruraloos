class GuestUsers::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: 'ゲストユーザーとしてログインしました。'
    notification = Notification.new(visiter_id: 1, visited_id: current_user.id, action: "new")
    notification.save
  end
end
