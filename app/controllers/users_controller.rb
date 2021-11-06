class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :next_step]
  before_action :ensure_correct_user, only: [:edit, :update, :next_step]

  def show
    if user_signed_in?
      @user = User.find(params[:id])
      @posts = @user.posts.page(params[:page]).order(updated_at: :desc)
    else
      flash[:notice] = "ログインして下さい（ゲストログインが便利です！）"
      redirect_to new_user_session_path
    end
  end

  def sort
    @user = User.find(params[:id])
    if params[:option].to_i == 1
      @posts = @user.posts.page(params[:page]).order(updated_at: :desc).per(25)
    else
      @posts = Kaminari.paginate_array(Post.find(Favorite.where(user_id: @user.id).pluck(:post_id))).page(params[:page]).per(25)
      #Post.find(~)は配列になっていて、配列に対してkaminariを使うには上記のようになる
    end
    render :show
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user_prefectures = @user.user_prefectures
    if @user_prefectures.exists?
      if @user.update(user_params)
        redirect_to edit_user_prefectures_path
        # flash[:notice] = "ユーザー情報を更新しました"
      else
        render :edit
      end
    else
      if @user.update(user_params)
        redirect_to new_user_prefectures_path
        # flash[:notice] = "ユーザー情報を更新しました"
      else
        render :edit
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    if @user != current_user
      flash[:notice] = "他のユーザーの情報は変更できません"
      redirect_to user_path(current_user)
    end
  end
end
