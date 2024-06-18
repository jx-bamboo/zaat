class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :async
  
  has_many :invited_users, dependent: :destroy
  has_one :token, dependent: :destroy
  has_many :token_changes, dependent: :destroy
  has_many :orders, dependent: :destroy
  
  # validates :email, uniqueness: { scope: :address }
  validates :address, uniqueness: true

  before_create :generate_invitation_code

  private 
  
  def generate_invitation_code
    self.invitation_code = SecureRandom.hex(4)
  end
  
end
