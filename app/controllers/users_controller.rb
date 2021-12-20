class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, only: [:sort, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:prefecture).page(params[:page]).order(updated_at: :desc)
    redirect_to new_user_session_path, flash: { notice: 'ログインして下さい（ゲストログインが便利です！）' } unless user_signed_in?
  end

  def sort
    @user = User.find(params[:id])
    # sort_users_postsメソッドはuser.rbに定義
    if @user.sort_users_posts(params[:option]).class == Array
      @posts = Kaminari.paginate_array(@user.sort_users_posts(params[:option])).page(params[:page]).per(25)
    else
      @posts = @user.sort_users_posts(params[:option]).page(params[:page]).per(25)
    end
    render :show
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user_prefectures = @user.user_prefectures
    update_depending_on_condition(@user_prefectures, @user, user_params) # users_helperに定義
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user), flash: { notice: "他のユーザーの情報は変更できません" } if !@user.be_identical?(current_user)
  end
end
