class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  # before_action :find_user, except: %i[create index]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def latest_users
    users = User.limit(3).order(created_at: :desc)
    render json: users
  end

  def show
    user = User.select('users.name, users.handle,users.id,users.image_url').find_by(handle: params[:handle])
    # current_user_likes = get_current_user_likes(user.posts)
    # user.merge!(posts: user.posts.count)
    data = {
      user:
    }
    data.merge!(posts: user.posts.count)
    render json: data
  end

  def user_posts
    user = User.find_by(handle: params[:handle])
    posts = user.posts.order(created_at: :desc).map { |reply| reply.create_post_return_structure(@current_user) }
    render json: posts
  end

  def user_likes
    user = User.find_by(handle: params[:handle])
    posts = Post.where(user_id: user.id, id: user.likes.pluck(:post_id)).order(created_at: :desc).map do |reply|
      reply.create_post_return_structure(@current_user)
    end
    # posts = user.likes.joins(:post).select('posts.*')
    render json: posts
  end

  def index
    # users = Post.order(created_at: :desc)
  end

  def user_params
    params.permit(:handle, :password, :name, :image_url)
  end
end
