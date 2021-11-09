class UserPrefecture < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture

  validates :status, presence: true

  enum status: { livepast: 0, livefuture: 1 }
  
  
end
