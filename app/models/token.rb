class Token < ApplicationRecord
  belongs_to :user
  has_many :token_changes
end
