class User < ApplicationRecord
  has_secure_password
  validates :handle, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :posts
  has_many :likes, dependent: :destroy

  has_many :follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :follows, source: :followed_user
  def create_return(_other_user)
    is_followed = _other_user.following.include?(self)
    {
      name:,
      handle:,
      verified:,
      image_url:,
      followed: is_followed
    }
  end

  def follow(other_user)
    follows.create(followed_user_id: other_user.id)
  end
end
