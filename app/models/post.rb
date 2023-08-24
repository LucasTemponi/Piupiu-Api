class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  has_many :replies, class_name: 'Post', foreign_key: 'main_post_id'
  belongs_to :main_post, class_name: 'Post'

  # def liked?(user)
  #   !!likes.find { |like| like.user_id == user.id }
  # end
  
  def create_post_return_structure(current_user)
    liked_by_current_user = current_user ? Like.where(user_id: current_user.id, post_id: id).any? : false
    {
      id:,
      message:,
      author: {
        name: user.name,
        handle: user.handle,
        verified: user.verified,
        image_url: user.image_url
      },
      likes: {
        total: likes.count
      },
      replies: {
        total: replies.count
      },
      liked: liked_by_current_user || false
    }
  end
  # def create_post_return_structure(current_user_likes)
  #   liked_by_current_user = current_user_likes.include?(id)
  #   {
  #     id:,
  #     message:,
  #     author: {
  #       name: user.name,
  #       handle: user.handle,
  #       verified: user.verified,
  #       image_url: user.image_url
  #     },
  #     likes: {
  #       total: likes.count
  #     },
  #     replies: {
  #       total: replies.count
  #     },
  #     liked: liked_by_current_user || false
  #   }
  # end
end
