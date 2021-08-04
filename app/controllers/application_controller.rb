# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authorized

  def authorized
    return unless logged_in_user.blank?

    render json: { message: 'Unable to authorized user! Please login again.' }, status: :unauthorized
  end

  def logged_in_user
    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    @user = User.find(user_id)
  end

  def encode_token(payload, exp = 30.minutes.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key)
  end

  def decoded_token
    auth_header = request.headers['Authorization']
    return unless auth_header

    token = auth_header.split(' ')[1]
    begin
      JWT.decode(token, Rails.application.secrets.secret_key)
    rescue JWT::DecodeError
      nil
    end
  end
end
