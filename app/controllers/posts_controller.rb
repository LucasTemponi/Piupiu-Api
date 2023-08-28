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
      render json: @post.create_post_return_structure(@current_user)
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    # current_user_likes = get_current_user_likes(@post)
    render json: @post.create_post_return_structure(@current_user)
  end

  def pius
    @pius = Post.where(main_post_id: nil).joins(:user).order(created_at: :desc)
    # current_user_likes = get_current_user_likes(@pius)
    render json: @pius.map { |piu| piu.create_post_return_structure(@current_user) }
  end

  def my_pius
    # current_user_likes = get_current_user_likes(@post)
    pius_to_return = @current_user.posts.order(created_at: :desc).map do |piu|
      piu.create_post_return_structure(@current_user)
    end
    render json: pius_to_return
  end

  def index
    # @posts = Post.order(created_at: :desc)
  end

  def get_current_user_likes(posts)
    Like.where(user_id: @current_user.id, post_id: posts.ids).pluck(:post_id)
  end
end
