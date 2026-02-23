module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: [:login, :register]

      def register
        user = User.new(user_params)
        return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity unless user.save

        token = JwtService.encode(user_id: user.id)
        render json: { token: token, user: user_response(user) }, status: :created
      end

      def login
        user = User.find_by(email: params[:email]&.downcase)
        return render json: { error: 'Invalid email or password.' }, status: :unauthorized unless user&.authenticate(params[:password])

        token = JwtService.encode(user_id: user.id)
        render json: { token: token, user: user_response(user) }, status: :ok
      end

      def me
        render json: { user: user_response(current_user) }, status: :ok
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end

      def user_response(user)
        { id: user.id, name: user.name, email: user.email, created_at: user.created_at }
      end
    end
  end
end
