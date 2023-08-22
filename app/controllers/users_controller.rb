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
    user = User.find_by(handle: params[:handle])
    data = {
      user:,
      posts: user.posts.order(created_at: :desc)
    }
    render json: data
  end

  def index
    # users = Post.order(created_at: :desc)
  end

  def user_params
    params.permit(:handle, :password, :name, :image_url)
  end
end
