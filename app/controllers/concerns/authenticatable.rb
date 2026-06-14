module Authenticatable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user
  end

  # Call this in a before_action to require a valid Bearer token.
  def authenticate_user!
    token = extract_token
    return render_unauthorized("Missing token") if token.nil?

    payload = JsonWebToken.decode(token)
    return render_unauthorized("Invalid or expired token") if payload.nil?

    @current_user = User.find_by(id: payload[:user_id])
    render_unauthorized("User not found") unless @current_user
  end

  # Call this after authenticate_user! to enforce host-only access.
  def authenticate_host!
    return render_forbidden("Host access required") unless current_user&.role == "host"
  end

  private

  def extract_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.start_with?("Bearer ")

    auth_header.split(" ", 2).last.presence
  end

  def render_unauthorized(message = "Unauthorized")
    render json: { error: message }, status: :unauthorized
  end

  def render_forbidden(message = "Forbidden")
    render json: { error: message }, status: :forbidden
  end
end
