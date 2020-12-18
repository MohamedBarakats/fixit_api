# frozen_string_literal: true

# spec/support/controller_spec_helper.rb
module ControllerSpecHelper
  def token_generator(user_id:)
    JsonWebToken.encode(payload: { user_id: user_id })
  end

  def expired_token_generator(user_id:)
    JsonWebToken.encode(payload: { user_id: user_id }, exp: (Time.now.to_i - 10))
  end

  def valid_headers
    {
      'Authorization' => token_generator(user_id: user.id),
      'Content-Type' => 'application/json'
    }
  end

  def invalid_headers
    {
      'Authorization' => nil,
      'Content-Type' => 'application/json'
    }
  end
end
