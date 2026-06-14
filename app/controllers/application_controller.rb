class ApplicationController < ActionController::API
  include Authenticatable

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.record.errors.full_messages.join(", ") }, status: :unprocessable_entity
  end

  private

  def user_json(user)
    {
      id:    user.id,
      name:  user.name,
      email: user.email,
      role:  user.role,
    }
  end
end
