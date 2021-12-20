class SearchsController < ApplicationController
  def search
    @content = params[:content]
    @prefecture_id = params[:prefecture_id]
    @method = params[:method]
    @records = Post.search_for(@content, @prefecture_id, @method).page(params[:page]).order(updated_at: :desc)
  end
end
