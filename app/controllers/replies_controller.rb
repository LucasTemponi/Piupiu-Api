class RepliesController < PostsController
  before_action :authorize_request

  def create
    reply_params = params.permit(:message)
    @post = Post.find(params[:id])
    reply = Post.create(message: reply_params[:message], main_post_id: @post.id, user_id: @current_user.id)
    if reply.save
      render json: reply
    else
      render json: reply.errors, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    total = @post.replies.count
    puts ["\n\n =========== Current user:  ", @current_user]
    current_user_likes = Like.where(user_id: @current_user.id).pluck(:post_id)
    puts ["\n\n =========== ", current_user_likes]
    replies = @post.replies.order(created_at: :desc).map { |reply|
      reply.create_post_return_structure(current_user_likes)
  }
    render json: { total:, replies: }
  end
end
