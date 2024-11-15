class ApplicationController < ActionController::API
  require 'jwt'
  include ActionController::Cookies
  
  before_action :authenticate_request
  
  rescue_from JWT::DecodeError do |e|
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
  
  private
  
  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(token)
      @current_user = User.find_by(id: decoded[:user_id]) if decoded
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end
end
