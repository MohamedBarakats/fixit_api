# frozen_string_literal: true

class AuthenticateUser
  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(payload: { user_id: user.id }) if user
  end

  private

    attr_reader :email, :password

    def user
      user = User.find_by(email: email)
      return user if user&.authenticate(password)

      # raise Authentication error if credentials are invalid
      raise(ExceptionHandler::AuthenticationError, JsonWebTokenMessages.invalid_credentials)
    end
end
