class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = extract_token_from_header
    return render json: { error: 'Authorization token not found.' }, status: :unauthorized unless token

    begin
      decoded = JwtService.decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :unauthorized
    rescue => e
      render json: { error: e.message }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def extract_token_from_header
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end
end
