class Prefecture < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :user_prefectures, dependent: :destroy

  def find_people(status)
    user_prefectures.where(status: status)
  end
end
