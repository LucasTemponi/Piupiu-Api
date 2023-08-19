class LikesController < ApplicationController
  before_action :find_post, except: :destroy
  before_action :authorize_request, except: :show

  def create
    like = @post.likes.new(user_id: @current_user.id)
    if like.valid?
      like.save
      render json: @post
    else
      render json: { errors: 'Você já curtiu esse post' }, status: :unprocessable_entity
    end
  end

  def show
    total = @post.likes.count
    users = @post.likes.joins(:user).pluck(:handle)
    render json: { total:, users: }
  end

  def destroy
    post_id = params[:id]
    @like = Like.find_by!(post_id:, user_id: @current_user.id)
    @like.destroy
    render json: @like
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'not found' }, status: :not_found
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end
end
