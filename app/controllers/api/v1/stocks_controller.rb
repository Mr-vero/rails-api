module Api
    module V1
      class StocksController < ApplicationController
        def price
          stock = Stock.find_by!(symbol: params[:symbol])
          
          render json: {
            data: {
              symbol: stock.symbol,
              price: format_money(stock.wallet.balance)
            }
          }
        end
  
        def prices
          symbols = params[:symbols]&.split(',') || []
          stocks = Stock.where(symbol: symbols)
          
          render json: {
            data: stocks.map { |stock|
              {
                symbol: stock.symbol,
                price: format_money(stock.wallet.balance)
              }
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