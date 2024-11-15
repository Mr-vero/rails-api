module Api
    module V1
      class StocksController < ApplicationController
        def price
          symbol = params[:symbol]
          # Your implementation to fetch stock price
          render json: { symbol: symbol, price: 150.00 } # Mock response for now
        end
  
        def prices
          symbols = params[:symbols]
          # Your implementation to fetch multiple stock prices
          prices = symbols.map { |s| { symbol: s, price: 150.00 } }
          render json: { prices: prices }
        end
  
        def price_all
          client = LatestStockPrice::Client.new(ENV['RAPIDAPI_KEY'])
          result = client.price_all
          render json: result
        end
      end
    end
  end