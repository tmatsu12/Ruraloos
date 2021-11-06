class UserPrefecturesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def new
    @user_prefecture = UserPrefecture.new
  end

  def create
    @user_prefecture = UserPrefecture.new(user_prefecture_params)
    if @user_prefecture.save
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def edit
    @user = current_user
    @user_prefecture = UserPrefecture.find_by(user_id: @user.id)
  end

  def update
    @user = current_user
    @user_prefecture = UserPrefecture.find_by(user_id: @user.id)
    if @user_prefecture.update(user_prefecture_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_prefecture_params
    params.require(:user_prefecture).permit(:user_id, :prefecture_id, :status)
  end
end
