class Draft < ApplicationRecord
  belongs_to :user

  # has_one_attached :model
  has_many_attached :model_file

  validates :model_file, presence: true
  # validates :model_file, attachment_content_type: { content_type: /image/ }
  enum status: [:pending, :creating, :completed]

  def model_file_count
    model_file.size
  end
end
