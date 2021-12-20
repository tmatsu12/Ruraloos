class Prefecture < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :user_prefectures, dependent: :destroy

  def find_people_livepast
    user_prefectures.includes(:user).livepast
  end

  def find_people_livefuture
    user_prefectures.includes(:user).livefuture
  end

  def sort_pref_posts(option)
    if option == "SortByOrder"
      posts.all.includes(:user).order(updated_at: :desc)
    else
      Post.includes(:user, :prefecture)
          .where(id: Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
          .select { |post| post.prefecture.id == id }
    end
  end
end
