class HomesController < ApplicationController
  def top
    @posts = Post.all.includes(:prefecture, :user).page(params[:page]).order(updated_at: :desc).per(4)
    @prefs_livefuture = Prefecture.joins(:user_prefectures).where("user_prefectures.status": "livefuture").group("prefectures.name").order("count_all desc").limit(3).count
  end

  def about
  end

  def region
    render "region/#{params[:region]}"
  end
end
