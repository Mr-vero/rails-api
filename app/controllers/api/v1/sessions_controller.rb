module Api
    module V1
      class SessionsController < ApplicationController
        skip_before_action :authenticate_request, only: :create
  
        def create
          user = User.find_by(email: params[:email])
          if user&.authenticate(params[:password])
            token = AuthTokenService.encode(user_id: user.id)
            render json: { token: token, user: user.as_json(except: :password_digest) }
          else
            render json: { error: 'Invalid credentials' }, status: :unauthorized
          end
        end
  
        def destroy
          # Add token to blacklist if needed
          # TokenBlacklist.create(token: request.headers['Authorization'])
          head :no_content
        end
      end
    end
  end