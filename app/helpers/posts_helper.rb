module PostsHelper
  def sort_posts(option)
    if option == "SortByOrder"
      Post.all.includes(:prefecture, :user).order(updated_at: :desc)
    else
      Post.includes(:prefecture, :user).find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
    end
  end
end
