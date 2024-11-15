module Api
    module V1
      class StocksController < ApplicationController
        require "latest_stock_price"

        def price
          symbol = stock_params[:symbol]
          price_data = LatestStockPrice.client.price(symbol)
          render json: { data: price_data }
        rescue LatestStockPrice::Error => e
          render json: { error: e.message }, status: :unprocessable_entity
        end

        def price_all
          symbols = stock_params[:symbols]
          price_data = symbols.map { |symbol| LatestStockPrice.client.price(symbol) }
          render json: { data: price_data }
        rescue LatestStockPrice::Error => e
          render json: { error: e.message }, status: :unprocessable_entity
        end

        def search
          query = stock_params[:query]
          search_results = LatestStockPrice.client.search(query)
          render json: { data: search_results }
        rescue LatestStockPrice::Error => e
          render json: { error: e.message }, status: :unprocessable_entity
        end

        def enhanced
          symbol = stock_params[:symbol]
          enhanced_data = LatestStockPrice.client.enhanced_data(symbol)
          render json: { data: enhanced_data }
        rescue LatestStockPrice::Error => e
          render json: { error: e.message }, status: :unprocessable_entity
        end

        def timeseries
          symbol = stock_params[:symbol]
          interval = stock_params[:interval] || "day"
          period = stock_params[:period] || "1y"

          timeseries_data = LatestStockPrice.client.timeseries(
            symbol,
            interval: interval,
            period: period
          )
          render json: { data: timeseries_data }
        rescue LatestStockPrice::Error => e
          render json: { error: e.message }, status: :unprocessable_entity
        end

        private

        def stock_params
          params.require(:stock).permit(
            :symbol,
            :query,
            :interval,
            :period,
            symbols: []
          )
        end
      end
    end
end
