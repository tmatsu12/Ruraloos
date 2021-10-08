class PostsController < ApplicationController
  
  def index
    @user = current_user
    @prefecture = Prefecture.find(params[:prefecture_id])
    @posts = @prefecture.posts.page(params[:page]).order(updated_at: :desc)
    @residents = @prefecture.residents
    @wannalivings = @prefecture.wannalivings
  end
end
