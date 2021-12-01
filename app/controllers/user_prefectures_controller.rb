class UserPrefecturesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def new
    @user_prefecture = UserPrefecture.new
  end

  def create
    # models/user.rbに定義
    current_user.create_user_prefecture_by_status!(params[:user_prefecture][:prefecture_livepast_ids], "livepast")
    current_user.create_user_prefecture_by_status!(params[:user_prefecture][:prefecture_livefuture_ids], "livefuture")
    redirect_to user_path(current_user)
  end

  def edit
    @user_prefecture = UserPrefecture.find_by(user_id: current_user.id)
  end

  def update
    # 一旦リセットする
    current_user.user_prefectures.delete_all
    current_user.create_user_prefecture_by_status!(params[:user_prefecture][:prefecture_livepast_ids], "livepast")
    current_user.create_user_prefecture_by_status!(params[:user_prefecture][:prefecture_livefuture_ids], "livefuture")
    redirect_to user_path(current_user)
  end

  private

  def user_prefecture_params
    params.require(:user_prefecture).permit(:user_id, :prefecture_livepast_ids, :prefecture_livefuture_ids)
  end
end
