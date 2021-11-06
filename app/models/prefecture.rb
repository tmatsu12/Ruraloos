class Prefecture < ApplicationRecord
  # has_many :wannalivings, dependent: :destroy, class_name: 'User', foreign_key: 'prefecture1_id'
  # has_many :residents, dependent: :destroy, class_name: 'User', foreign_key: 'prefecture2_id'
  # has_many :pastlivings, dependent: :destroy, class_name: 'User', foreign_key: 'prefecture3_id'
  has_many :posts, dependent: :destroy
  has_many :user_prefectures, dependent: :destroy
end
