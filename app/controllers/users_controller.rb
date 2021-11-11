class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, only: [:sort, :edit, :update, :finish]
  before_action :ensure_correct_user, only: [:edit, :update, :finish]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).order(updated_at: :desc)
    redirect_to new_user_session_path, flash: { notice: 'ログインして下さい（ゲストログインが便利です！）' } unless user_signed_in?
  end

  def sort
    @user = User.find(params[:id])
    @posts = @user.sort_users_posts(params[:option].to_i, params[:page]) #user.rbに定義
    render :show
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user_prefectures = @user.user_prefectures
    update_depending_on_condition(@user_prefectures, @user, user_params) #users_helperに定義
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
