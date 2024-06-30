class Draft < ApplicationRecord
  belongs_to :user

  has_one_attached :model
end
