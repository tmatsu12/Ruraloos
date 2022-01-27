class HomesController < ApplicationController
  def top
    @posts = Post.all.includes(:prefecture, :user).page(params[:page]).order(updated_at: :desc).per(4)
    # ランキング用のハッシュ。県名がキーで、数が値
    @prefs_livefuture = Prefecture.joins(:user_prefectures).where("user_prefectures.status": "livefuture").group("prefectures.name").order("count_all desc").limit(3).count
  end

  def about
  end

  def region
    # マップの地方をクリックすると、ルーティングに従い、params[:region]に地方名が入る
    # ルーティングによるとhomes#regionで処理される。views/region/地方名が表示される
    render "region/#{params[:region]}"
  end
end
