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

  def create
    @post = Post.new(post_params)
    @prefecture = @post.prefecture
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      @user = current_user
      @prefecture = Prefecture.find(session[:prefecture])
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :city, :body, :prefecture_id, :image, :evaluation, :body1, :body2, :body3)
  end

end
