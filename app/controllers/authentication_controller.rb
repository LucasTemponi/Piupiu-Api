class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.find_by(handle: params[:handle])
    if @user&.authenticate(params[:password])
      time = Time.now + 30.days.to_i
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token:, exp: time.strftime('%m-%d-%Y %H:%M'),
                     user: {
                       handle: @user.handle,
                       name: @user.name,
                       image_url: @user.image_url,
                       verified: @user.verified
                     } }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def login_params
    params.permit(:handle, :password)
  end
end
