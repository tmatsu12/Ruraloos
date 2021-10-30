class HomesController < ApplicationController
  def top
    @posts = Post.all.reverse_order.page(params[:page]).per(4)
  end

  def about
  end

  def region
    render "region/#{params[:region]}"
  end
end
