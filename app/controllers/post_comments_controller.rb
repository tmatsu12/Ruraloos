class PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.new(parent_id: params[:parent_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.post_id = @post.id
    @post_comment.user_id = current_user.id
    if @post_comment.save
      @post.create_notification_comment!(current_user, @post_comment.id)
    else
      render 'error'
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
    @post_comment.update(post_comment_params)
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    post_comment = @post.post_comments.find(params[:id])
    post_comment.destroy
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment, :parent_id, :evaluation)
  end

end
