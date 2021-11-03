class SearchsController < ApplicationController
  def search
    @user = current_user
    @content = params[:content]
    @prefecture_id = params[:prefecture_id]
    @method = params[:method]
    @records = search_for(@content, @prefecture_id, @method)
  end

  private

  def search_for(content, prefecture_id , method)
    if method == 'perfect'
      Post.where(prefecture_id: prefecture_id) || Post.where(city: content)
    else
      Post.where(prefecture_id: prefecture_id) || Post.where('city LIKE ?', "%#{content}%")
    end
  end
end
