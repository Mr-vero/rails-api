class ApplicationController < ActionController::API
  include ActionController::Cookies
  
  before_action :authenticate_request
  
  attr_reader :current_user
  
  private
  
  def authenticate_request
    token = extract_token_from_header
    payload = AuthTokenService.decode(token)
    
    if payload
      @current_user = User.find_by(id: payload[:user_id])
    end
    
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
  
  def extract_token_from_header
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end
end
