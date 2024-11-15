module Api
    module V1
      class StocksController < ApplicationController
        def price
          client = LatestStockPrice::Client.new(ENV['RAPIDAPI_KEY'])
          result = client.price(params[:symbol])
          render json: result
        end
  
        def prices
          client = LatestStockPrice::Client.new(ENV['RAPIDAPI_KEY'])
          result = client.prices(params[:symbols])
          render json: result
        end
  
        def price_all
          client = LatestStockPrice::Client.new(ENV['RAPIDAPI_KEY'])
          result = client.price_all
          render json: result
        end
      end
    end
  end