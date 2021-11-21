module PostsHelper
  def sort_posts(option, page)
    if option == 1
      Post.all.includes(:prefecture, :user).page(page).order(updated_at: :desc).per(25)
    else
      Kaminari.paginate_array(Post.includes(:prefecture, :user).find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))).page(page).per(25)
      # Post.find(~)は配列になっていて、配列に対してkaminariを使うには上記のようになる
    end
  end
end
