class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :user_prefectures, dependent: :destroy

  attachment :profile_image

  validates :name, presence: true
  validates :name, length: { maximum: 20 }
  validates :introduction, length: { maximum: 800 }

  def find_prefectures(status)
    user_prefectures.includes(:prefecture).where(status: status)
  end

  def be_identical?(user)
    self == user
  end

  def sort_users_posts(option)
    if option == "SortByOrder"
      posts.includes(:prefecture).order(updated_at: :desc)
    else
      Post.includes(:prefecture, :user).find(Favorite.where(user_id: id).pluck(:post_id))
    end
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end

  def create_user_prefecture_by_status!(ids, status)
    ids.each do |pref_id|
      next if pref_id.blank?
      user_prefectures.create!(status: status, prefecture_id: pref_id)
    end
  end

  def create_user_prefecture!(prefecture_livepast_ids:, prefecture_livefuture_ids:)
    if prefecture_livepast_ids.present?
      create_user_prefecture_by_status!(prefecture_livepast_ids, 'livepast')
    end

    if prefecture_livefuture_ids.present?
      create_user_prefecture_by_status!(prefecture_livefuture_ids, 'livefuture')
    end
  end
end
