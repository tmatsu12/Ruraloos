module UsersHelper
  def update_depending_on_condition(user_prefectures, user, user_params)
    if user_prefectures.exists?
      user.update(user_params) ? (redirect_to edit_user_prefectures_path) : (render :edit)
    else
      user.update(user_params) ? (redirect_to new_user_prefectures_path) : (render :edit)
    end
  end
end
