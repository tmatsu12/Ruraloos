class UserPrefecture < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture

  validates :status, presence: true

  enum status: { livepast: 0, livefuture: 1 }

  def prefecture_name
    prefecture.name
  end

  def prefecture_id
    prefecture.id
  end

  def user_name
    user.name
  end
end
