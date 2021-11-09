class UserPrefecturesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def new
    @user_prefecture = UserPrefecture.new
  end

  def create
    current_user.create_user_prefecture_by_status!(params[:user_prefecture][:prefecture_livepast_ids], "livepast")
    current_user.create_user_prefecture_by_status!(params[:user_prefecture][:prefecture_livefuture_ids], "livefuture")
    redirect_to user_path(current_user)
  end

  def edit
    @user = current_user
    @user_prefecture = UserPrefecture.find_by(user_id: @user.id)
  end

  def update
    @user = current_user
    @user.user_prefectures.delete_all
    #@user_prefecture = UserPrefecture.find_by(user_id: @user.id)
  #  if @user_prefecture.update(user_prefecture_params)
      params[:user_prefecture][:prefecture_livepast_ids].each do |pref_id|
        @user.user_prefectures.create!(status: :livepast, prefecture_id: pref_id ) if pref_id.present?
      end

      params[:user_prefecture][:prefecture_livefuture_ids].each do |pref_id|
        @user.user_prefectures.create!(status: :livefuture, prefecture_id: pref_id ) if pref_id.present?
      end
    #if @user.user_prefectures.create!(status: :livepast, prefecture_id: params[:user_prefecture][:prefecture_livepast_ids] )
      redirect_to user_path(@user)
    #else
    #  render :edit
    #end
  end

  private

  def user_prefecture_params
    params.require(:user_prefecture).permit(:user_id, :prefecture_livepast_ids, :prefecture_livefuture_ids)
  end
end
