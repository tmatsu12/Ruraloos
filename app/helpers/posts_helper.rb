module PostsHelper
  def sort_posts(option)
    if option == "SortByOrder"
      Post.all.includes(:prefecture, :user).order(updated_at: :desc)
    else
      # findの引数が配列なので、sort_postsの戻り値も配列になる
      # Post.joins(:favorites).group("posts.id").order("count_all desc").countでも良い
      Post.includes(:prefecture, :user).find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
    end
  end
end
