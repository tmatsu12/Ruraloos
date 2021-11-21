class HomesController < ApplicationController
  def top
    @posts = Post.all.includes(:prefecture, :user).page(params[:page]).order(updated_at: :desc).per(4)
    @temp_ids = UserPrefecture.where(status: "livefuture").group(:prefecture_id).order('count(prefecture_id) desc').limit(3).pluck(:prefecture_id)
  end

  def about
  end

  def region
    render "region/#{params[:region]}"
  end
end
