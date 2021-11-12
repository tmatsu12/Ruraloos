class Inquiry
  include ActiveModel::Model

  attr_accessor :name, :email, :message

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 30 }
  validates :message, presence: true, length: { maximum: 500 }
end
