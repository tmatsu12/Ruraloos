class PostCommentsController < ApplicationController

  def new
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.new(parent_id: params[:parent_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.post_id = @post.id
    @post_comment.user_id = current_user.id
    unless @post_comment.save
      render 'error'
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment, :parent_id)
  end
end
