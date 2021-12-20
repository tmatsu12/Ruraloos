class Prefecture < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :user_prefectures, dependent: :destroy

  def find_people(status)
    user_prefectures.includes(:user).where(status: status)
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
