class TokenChange < ApplicationRecord
  belongs_to :token
  belongs_to :user
end
