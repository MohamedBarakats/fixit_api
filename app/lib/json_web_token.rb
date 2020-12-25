# frozen_string_literal: true

class JsonWebToken
  HMAC_SECRET = Rails.application.secrets.secret_key_base
  HS256_ALGORITHM = 'HS256'

  def self.encode(payload:, exp: 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET, HS256_ALGORITHM)
  end

  def self.decode(token:)
    body = JWT.decode(token, HMAC_SECRET, true, algorithm: HS256_ALGORITHM)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end
