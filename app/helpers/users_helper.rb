module UsersHelper
  def update_depending_on_condition(user_prefectures, user, user_params)
    if user_prefectures.exists?
      if user.update(user_params)
        redirect_to edit_user_prefectures_path
      else
        render :edit
      end
    else
      if user.update(user_params)
        redirect_to new_user_prefectures_path
      else
        render :edit
      end
    end
  end
end
