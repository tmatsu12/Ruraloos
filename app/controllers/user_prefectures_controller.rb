class UserPrefecturesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def new
    @user_prefecture = UserPrefecture.new
  end

  def create
    begin
    current_user.create_user_prefecture!(
      prefecture_livepast_ids: params[:user_prefecture][:prefecture_livepast_ids],
      prefecture_livefuture_ids: params[:user_prefecture][:prefecture_livefuture_ids]
    )
    rescue ActiveRecord::RecordInvalid => e
      logger.error e.full_messages
    ensure
      redirect_to user_path(current_user)
    end
  end

  def edit
    @user_prefecture = UserPrefecture.find_by(user_id: current_user.id)
  end

  def update
    # 一旦リセットする
    current_user.user_prefectures.delete_all
    # createと同じ処理
    create
  end

  private

  def user_prefecture_params
    params.require(:user_prefecture).permit(:user_id, :prefecture_livepast_ids, :prefecture_livefuture_ids)
  end
end
