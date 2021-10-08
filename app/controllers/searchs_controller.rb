class SearchsController < ApplicationController
  def search
    # @model = params[:model]
    @user = current_user
    @content = params[:content]
    @method = params[:method]
    @records = search_for(@content, @method)
  end

  private

  def search_for(content, method)
    # if model == 'post'
    if method == 'perfect'
      Post.where(city: content)
    else
      Post.where('city LIKE ?', "%#{content}%")
    end
    # end
  end
end
