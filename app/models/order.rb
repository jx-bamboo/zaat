class Order < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :txhash, presence: true

  enum status: {pending: 0, success_one: 1, success_two: 2}

  scope :my_order_pendding, -> { where(status: 0).order(created_at: :desc).limit(3)}

  # def pending?
  #   status == 0
  # end
end
