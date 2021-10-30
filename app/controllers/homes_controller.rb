class HomesController < ApplicationController
  def top
    @posts = Post.all.page(params[:page]).order(updated_at: :desc).per(4)
  end

  def about
  end

  def region
    render "region/#{params[:region]}"
  end
end
