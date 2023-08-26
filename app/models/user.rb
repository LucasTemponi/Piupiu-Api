class User < ApplicationRecord
  has_secure_password
  validates :handle, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :posts
  has_many :likes, dependent: :destroy

  def create_return
    {
      name:,
      handle:,
      verified:,
      image_url:
    }
  end
end
