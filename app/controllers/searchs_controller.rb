class SearchsController < ApplicationController
  def search
    @content = params[:content]
    @prefecture_id = params[:prefecture_id]
    @method = params[:method]
    @records = search_for(@content, @prefecture_id, @method).page(params[:page]).order(updated_at: :desc)
  end

  private

  def search_for(content, prefecture_id, method)
    if method == 'perfect'
      if content != ""
        Post.includes(:prefecture, :user).where(city: content)
      else
        Post.includes(:prefecture, :user).where(prefecture_id: prefecture_id)
      end
    else
      if content != ""
        Post.includes(:prefecture, :user).where('city LIKE ?', "%#{content}%")
      else
        Post.includes(:prefecture, :user).where(prefecture_id: prefecture_id)
      end
    end
  end
end
