module Api
    module V1
      class WalletsController < ApplicationController
        def show
          wallet = current_user.wallet
          render json: {
            data: {
              id: wallet.id,
              balance: format_money(wallet.balance),
              currency: wallet.currency
            }
          }
        end

        def balance
          wallet = current_user.wallet
          render json: {
            data: {
              balance: format_money(wallet.balance)
            }
          }
        end

        private

        def format_money(money)
          {
            amount: money.to_f,
            currency: money.currency.to_s
          }
        end
      end
    end
end
