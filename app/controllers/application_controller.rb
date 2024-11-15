class ApplicationController < ActionController::API
  include ActionController::Cookies
  
  before_action :authenticate_request
  
  rescue_from JWT::DecodeError do |e|
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
  
  private
  
  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token)
    
    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end
end
