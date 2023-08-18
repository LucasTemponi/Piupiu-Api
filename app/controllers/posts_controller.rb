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
    @pius = Post.joins(:user).select('posts.id', 'posts.message', 'users.handle', 'users.name',
                                     'users.image_url','users.verified').order(created_at: :desc)
    render json: @pius
  end

  def my_pius
    render json: @current_user.posts.order(created_at: :desc)
  end

  def index
    # @posts = Post.order(created_at: :desc)
  end
end
