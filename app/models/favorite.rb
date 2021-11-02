class Favorite < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post
  belongs_to :post_comment, optional: true
end
