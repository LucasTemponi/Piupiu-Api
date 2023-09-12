class FollowsController < ApplicationController
  before_action :authorize_request
  before_action :find_user

  def create
    follow = @current_user.follow(@followed_user)
    if follow.valid?
      follow.save
      render json: @followed_user
    else
      render json: { errors: 'Você já curtiu esse post' }, status: :unprocessable_entity
    end
  end

  def destroy
    @like = Follow.find_by!(followed_user_id: @followed_user.id, follower_id: @current_user.id)
    @like.destroy
    render json: @like
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'not found' }, status: :not_found
  end

  private

  def find_user
    @followed_user = User.find_by(handle: params[:handle])
  end
end
