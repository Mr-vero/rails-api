module Api
    module V1
      class WalletsController < ApplicationController
        def show
          render json: current_user.wallet
        end
  
        def balance
          render json: { balance: current_user.wallet.balance }
        end
      end
    end
  end