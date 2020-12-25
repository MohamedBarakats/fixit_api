# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: :create
      def create
        user = User.create(user_params)
        if user.errors.empty?
          auth_token = AuthenticateUser.new(email: user.email, password: user.password).call
          response = { message: JsonWebTokenMessages.account_created, auth_token: auth_token,
                       user: user_serialized_object(user: user) }
          json_response(response: response, status: :created)
        else
          json_response(response: { errors: user.errors.full_messages }, status: :unprocessable_entity)
        end
      end

      private

        def user_serialized_object(user:)
          UserSerializer.new(user).serializable_hash
        end

        def user_params
          params.require(:user).permit(
            :first_name,
            :last_name,
            :email,
            :password,
            :password_confirmation
          )
        end
    end
  end
end
