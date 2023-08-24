class User < ApplicationRecord
  has_secure_password
  validates :handle, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true

  has_many :posts
  has_many :likes, dependent: :destroy

  def create_return
    {
      name: user.name,
      handle: user.handle,
      verified: user.verified,
      image_url: user.image_url
    }
  end
end
