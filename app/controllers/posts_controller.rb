class PostsController < ApplicationController

  def index
    @user = current_user
    @prefecture = Prefecture.find(params[:prefecture_id])
    @posts = @prefecture.posts.page(params[:page]).order(updated_at: :desc)
    @residents = @prefecture.residents
    @wannalivings = @prefecture.wannalivings
  end

  def new
    if user_signed_in?
      @prefecture = Prefecture.find(params[:prefecture_id])
      session[:prefecture] = params[:prefecture_id]
      @post = Post.new
      @user = current_user
    else
      flash[:notice] = "ログインして下さい（簡単ログインが便利です！）"
      redirect_to new_user_session_path
    end
  end
end
