class Order < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :txhash, presence: true

  enum status: [:pending, :creating, :completed]

  scope :my_order_pendding, -> { where(status: 0).order(created_at: :desc).limit(3)}

  # def pending?
  #   status == 0
  # end
end
