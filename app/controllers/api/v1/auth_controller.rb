module Api
  module V1
    class AuthController < ApplicationController
      before_action :authenticate_user!, only: [:me]

      # POST /api/v1/auth/signup
      def signup
        user = User.new(signup_params)

        unless user.save
          return render json: { error: user.errors.full_messages.join(", ") },
                        status: :unprocessable_entity
        end

        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user_json(user) }, status: :created
      end

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: login_params[:email].to_s.downcase.strip)

        unless user&.authenticate(login_params[:password])
          return render json: { error: "Invalid email or password" }, status: :unauthorized
        end

        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user_json(user) }
      end

      # GET /api/v1/auth/me
      def me
        render json: { user: user_json(current_user) }
      end

      private

      def signup_params
        params.permit(:name, :email, :password, :role).tap do |p|
          p[:email] = p[:email].to_s.downcase.strip if p[:email]
        end
      end

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
