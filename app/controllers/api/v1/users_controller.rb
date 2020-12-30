# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: :create
      def create
        user_object, errors = UserService.new.create(user_params: user_params)
        if errors.empty?
          json_response(response: user_object, status: :created)
        else
          render_errors(errors: errors, status: :unprocessable_entity)
        end
      end

      private

        def user_params
          params.require(:user).permit(
            :first_name,
            :last_name,
            :email,
            :password,
            :password_confirmation,
            :gender,
            :mobile_number
          )
        end
    end
  end
end
