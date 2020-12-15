# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token = AuthenticateUser.new(email: auth_params[:email],
                                      password: auth_params[:password]).call
    json_response(response: { auth_token: auth_token })
  end

  private

    def auth_params
      params.permit(:email, :password)
    end
end
