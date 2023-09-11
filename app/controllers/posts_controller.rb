class PostsController < ApplicationController
  before_action :authorize_request

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
    @user = User.find_by(handle: params[:handle]) if params[:handle]

    @pius = Post.where(main_post_id: nil).joins(:user).order(created_at: :desc)
    @pius = @pius.where(user_id: @user.id) if @user
    page = (params[:page] || 1).to_i
    per_page = (page_params[:per_page] || 10).to_i

    offset = (page - 1) * per_page
    total_pius = @pius.count
    total_pages = (total_pius / per_page.to_f).ceil

    @pius = @pius.offset(offset).limit(per_page)
    # current_user_likes = get_current_user_likes(@pius)
    return_item = {
      totalPius: total_pius,
      totalPages: total_pages,
      currentPage: page,
      data: @pius.map { |piu| piu.create_post_return_structure(@current_user) }
    }

    render json: return_item
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

  def page_params
    params.permit(:page, :per_page)
  end
end
