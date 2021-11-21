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

  def sort_users_posts(option, page)
    if option == 1
      posts.includes(:prefecture).page(page).order(updated_at: :desc).per(25)
    else
      Kaminari.paginate_array(Post.includes(:prefecture, :user).find(Favorite.where(user_id: id).pluck(:post_id))).page(page).per(25)
      # Post.find(~)は配列になっていて、配列に対してkaminariを使うには上記のようになる
    end
  end

  def self.guest # チェリー本「クラスメソッドの定義について：そのクラスに関連は深いものの、各インスタンスに含まれるデータは使わないメソッドを定義したい場合もある」
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end

  def create_user_prefecture_by_status!(ids, status)
    if status == "livepast"
      create_user_prefecture!(self, ids, status)
    else
      create_user_prefecture!(self, ids, status)
    end
  end

  private

  def create_user_prefecture!(user, ids, status)
    ids.each do |pref_id|
      user.user_prefectures.create!(status: status, prefecture_id: pref_id) if pref_id.present?
    end
  end
end
