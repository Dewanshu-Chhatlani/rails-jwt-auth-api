# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorized, only: %i[sign_up login]

  def sign_up
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { message: @user.errors.full_messages[0] }, status: :bad_request
    end
  end

  def login
    @user = User.find_by(email: user_params[:email])

    if @user&.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { message: 'Incorrect email or password!' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
