class Post < ApplicationRecord
  belongs_to :prefecture
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  is_impressionable

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  attachment :image
  geocoded_by :address

  validates :title, presence: true
  # validates :city, presence: true
  validates :body, presence: true
  validates :title, length: { maximum: 28 }
  validates :city, length: { maximum: 20 }
  validates :body, length: { maximum: 1000 }

  def create_notification_comment!(current_user, post_comment_id)
    # 自分以外に回答している人をすべて取得し、全員に通知を送る=>必要ないと判断
    # temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    # temp_ids.each do |temp_id|
    #   save_notification_comment!(current_user, post_comment_id, temp_id['user_id'])
    # end

    # 回答者に通知を送る
    save_notification_comment!(current_user, post_comment_id, user_id)
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
