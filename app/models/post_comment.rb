class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: 'PostComment', optional: true
  has_many   :replies, class_name: 'PostComment', foreign_key: :parent_id, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true
  validates :comment, length: { maximum: 1000 }
end
