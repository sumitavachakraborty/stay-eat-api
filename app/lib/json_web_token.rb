require "jwt"

module JsonWebToken
  ALGORITHM = "HS256".freeze
  EXPIRY    = 7.days

  module_function

  def secret
    ENV.fetch("JWT_SECRET") do
      Rails.application.secret_key_base
    end
  end

  # Encode a payload hash into a JWT string.
  # Automatically adds `exp` claim (7-day expiry).
  def encode(payload)
    expiry = payload[:exp] || (Time.now.utc + EXPIRY).to_i
    JWT.encode(payload.merge(exp: expiry), secret, ALGORITHM)
  end

  # Decode a JWT string back to a payload hash (symbol keys).
  # Returns nil if token is invalid or expired.
  def decode(token)
    decoded = JWT.decode(token, secret, true, algorithms: [ALGORITHM])
    decoded.first.symbolize_keys
  rescue JWT::DecodeError
    nil
  end
end
