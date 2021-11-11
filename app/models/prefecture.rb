class Prefecture < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :user_prefectures, dependent: :destroy

  def find_people(status)
    user_prefectures.where(status: status)
  end

  def sort_pref_posts(option, page)
    if option == 1
      self.posts.all.page(page).order(updated_at: :desc).per(25)
    else
      temp_ids = Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id)
      temp_array = []
      temp_ids.each do |temp_id|
        if Post.find(temp_id).prefecture.id == self.id
          temp_array << temp_id
        end
      end
      Kaminari.paginate_array(Post.find(temp_array)).page(page).per(25)
      #Post.find(~)は配列になっていて、配列に対してkaminariを使うには上記のようになる
    end
  end
end
