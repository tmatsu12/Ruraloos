class PostCommentsController < ApplicationController

  def new
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.new(parent_id: params[:parent_id])
  end
end
