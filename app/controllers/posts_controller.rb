class PostsController < ApplicationController
  before_action :authorize_request, except: :show

  def new
    @post = Post.new
  end

  def create
    # render json: @current_user
    post_params = params.require(:post).permit(:message)
    @post = @current_user.posts.new(post_params)
    if @post.save
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def pius
    @pius = Post.joins(:user).order(created_at: :desc)
    render json: @pius.map { |piu|
      @liked_by_current_user = Like.where(user_id: @current_user.id, post_id: piu.id)
      {
        id: piu.id,
        message: piu.message,
        author: {
          name: piu.user.name,
          handle: piu.user.handle,
          verified: piu.user.verified,
          image_url: piu.user.image_url
        },
        likes: {
          total: piu.likes.count
        },
        liked: @liked_by_current_user.any? || false
      }
    }
  end

  def my_pius
    render json: @current_user.posts.order(created_at: :desc)
  end

  def index
    # @posts = Post.order(created_at: :desc)
  end
end
