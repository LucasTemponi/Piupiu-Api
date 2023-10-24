class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  # before_action :find_user, except: %i[create index]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.create_return, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(handle: params[:handle])
    if @current_user.id != @user.id
      render json: { error: 'unauthorized' }, status: :unauthorized
      return
    end
    # return unless @user.update(update_user_params)

    render json: @user.create_return(@current_user), status: :ok if @user.update(update_user_params)

    # render json: @user.errors, status: :unprocessable_entity
  end

  def latest_users
    users = User.limit(3).order(created_at: :desc)
    render json: users.map { |user| user.create_return(@current_user) }
  end

  def show
    user = User.select('users.name, users.handle,users.id,users.image_url,users.description')
               .find_by(handle: params[:handle])
    data = {
      user:
    }
    data.merge!(posts: user.posts.count)
    data.merge!(followed: @current_user.following.include?(user))
    render json: data
  end

  def user_posts
    user = User.find_by(handle: params[:handle])
    current_user_likes = Like.where(user_id: @current_user.id).pluck(:post_id)
    posts = user.posts.order(created_at: :desc).map { |reply| reply.create_post_return_structure(current_user_likes) }
    render json: posts
  end

  def user_likes
    user = User.find_by(handle: params[:handle])
    current_user_likes = Like.where(user_id: @current_user.id).pluck(:post_id)
    posts = Post.where(id: user.likes.pluck(:post_id)).order(created_at: :desc).map do |reply|
      reply.create_post_return_structure(current_user_likes)
    end
    # posts = user.likes.joins(:post).select('posts.*')
    render json: posts
  end

  def index
    # users = Post.order(created_at: :desc)
  end

  def user_params
    params.permit(:name, :image_url, :description, :handle, :password)
  end

  def update_user_params
    params.compact_blank.permit(:name, :image_url, :description, :handle)
  end
end
