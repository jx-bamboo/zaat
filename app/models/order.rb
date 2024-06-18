class Order < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  scope :my_order_pendding, -> { where(status: 0).order(created_at: :desc)}
end
