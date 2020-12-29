# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern
  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end

  class MissingToken < StandardError; end

  class InvalidToken < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |error|
      render_errors(errors: { message: error.message }, status: :not_found)
    end
  end

  private

    # JSON response with message; Status code 401 - Unauthorized
    def unauthorized_request(error)
      render_errors(errors: { message: error.message }, status: :unauthorized)
    end

    def four_twenty_two(error)
      render_errors(errors: { message: error.message }, status: :unprocessable_entity)
    end
end
