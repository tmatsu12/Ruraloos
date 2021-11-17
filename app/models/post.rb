class Post < ApplicationRecord
  belongs_to :prefecture
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  is_impressionable

  geocoded_by :address

  validates :title, presence: true
  validates :body, presence: true
  validates :title, length: { maximum: 28 }
  validates :city, length: { maximum: 20 }
  validates :body, length: { maximum: 1000 }

  def written_by?(current_user)
    user == current_user
  end

  def prefecture_name
    prefecture.name
  end

  def favorites_count
    favorites.count
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def create_notification_comment!(current_user, post_comment_id)
    # 自分以外に回答(返信も含む)している人をすべて取得し、全員に通知を送る => #一旦保留
    # temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    # temp_ids.each do |temp_id| # この時点でtemp_idsはオブジェクトを要素にもつ配列である
    #   save_notification_comment!(current_user, post_comment_id, temp_id['user_id'])
    # end

    # 質問者に回答があったと通知を送る(ただし、回答への返信時は除く)
    save_notification_comment!(current_user, post_comment_id, user_id) unless PostComment.find(post_comment_id).be_reply?
  end

  def save_notification_comment!(current_user, post_comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の質問に対する回答の場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索

    temp = Notification.where(["visiter_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の質問に対するいいねの場合は、通知済みとする
      if notification.visiter_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
