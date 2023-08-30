class RepliesController < PostsController
  before_action :authorize_request, except: :show

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
    replies = @post.replies.map { |reply| reply.create_post_return_structure(@current_user) }
    render json: { total:, replies: }
  end
end
